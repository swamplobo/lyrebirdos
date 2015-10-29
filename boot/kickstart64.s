BITS 32
SECTION .mbhdr
EXTERN _loadStart
EXTERN _loadEnd
EXTERN _bssEnd
ALIGN 4
multibootHeader:
    DD 0xe85250d6 ;magic
    DD 0 ; architecture
    DD multibootHeaderEnd - multibootHeader ;length
    DD -(0xe85250d6 + 0 + multibootHeaderEnd - multibootHeader) ; checksum
    
    ; tags
    
    ; sections override
    DW 2,0
    DD 24
    DD multibootHeader
    DD _loadStart
    DD _loadEnd
    DD _bssEnd
    
    ; Entry point override
    DW 3,0
    DD 12
    DD EntryPoint

    ALIGN 8
    
    DW 4,0
    DD 12
    DD 0x03 ; EGA mode

;    DW 5,1
;    DD 20
;    DD 1024 ; width
;    DD 768 ; height
;    DD 32 ; BPP?
   
    ALIGN 8

    DW 0,0
    DD 8 ; Hdr end mark
multibootHeaderEnd:

    
[SECTION .boot]
[GLOBAL EntryPoint]
[EXTERN Stack]
EntryPoint:
	mov eax, Gdtr1
	lgdt [eax]
 
	push 0x08
	push .GdtReady
	ret
 
.GdtReady:
	mov eax, 0x10
	mov ds, ax
	mov ss, ax
	mov esp, Stack
 
	call SetupPagingAndLongMode
 
	mov eax, Gdtr2
	lgdt [Gdtr2]
 
	push 0x08
	push .Gdt2Ready
	ret
    
[BITS 64]
[EXTERN kmain]
.Gdt2Ready:

	mov rax, 0x10
	mov ds, ax
	mov es, ax
	mov ss, ax
    mov fs, ax
    mov gs, ax
 
    call BlankScreen

	mov rsp,Stack + 0xFFFFFFFF80000000

    jmp .Gdt2Ready

	; If you later decide to unmap the lower zone, you will have an invalid Gdt if you're still using Gdtr2
	mov rax, Gdtr3
	lgdt [rax]
 
    
	mov rax, kmain
	call rax
	cli
	jmp $
    
[BITS 32]
[EXTERN Pml4]
[EXTERN Pdpt]
[EXTERN Pd]
SetupPagingAndLongMode:
	mov eax, Pdpt
	or eax, 1
	mov [Pml4], eax
	mov [Pml4 + 0xFF8], eax
 
	mov eax, Pd
	or eax, 1
	mov [Pdpt], eax
	mov [Pdpt + 0xFF0], eax
 
	mov dword [Pd], 0x000083
	mov dword [Pd + 8], 0x200083
	mov dword [Pd + 16], 0x400083
	mov dword [Pd + 24], 0x600083
 
	; Load CR3 with PML4
	mov eax, Pml4
	mov cr3, eax
 
	; Enable PAE
	mov eax, cr4
	or eax, 1 << 5
	mov cr4, eax
 
	; Enable Long Mode in the MSR
	mov ecx, 0xC0000080
	rdmsr
	or eax, 1 << 8
	wrmsr
 
	; Enable Paging
	mov eax, cr0
	or eax, 1 << 31
	mov cr0, eax
 
	ret
TmpGdt:
	DQ	0x0000000000000000
	DQ	0x00CF9A000000FFFF
	DQ	0x00CF92000000FFFF
	DQ	0x0000000000000000
	DQ	0x00A09A0000000000
	DQ	0x00A0920000000000
 
Gdtr1:
	DW	23
	DD	TmpGdt
 
Gdtr2:
	DW	23
	DD	TmpGdt + 24
	DD	0
 
Gdtr3:
	DW	23
	DQ	TmpGdt + 24 + 0xFFFFFFFF80000000


BlankScreen:
    mov edi, 0x0b8000
    mov ecx, 2000           ; 2000 elements (actually 8000 I think)
    mov eax, 0x8E208E20     ; 1:Blue bg, F:white fg, 20:blank space 
    rep stosd               ; Clear entire screen
    ret

ReadKey:
    in al, 0x64             ; Store key code in AL
    and al, 10b             ; Test IBF flag
    jz ReadKey              ; Wait for IBF = 1
    in al, 0x60             ; Read input buffer
    cmp al, 0       
    je ReadKey
    ret
