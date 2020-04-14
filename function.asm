section .text
    global strlen
    global strchr
    global memset
    global memcpy
    global strcmp
    global memmove
    global strncmp
    global strcasecmp
    global rindex
    global strstr
    global strpbrk
    global strcspn

strlen:
    push rbp
    mov rbp, rsp

    mov rax, 0
    start_strlen:
        cmp byte [rdi], 0
        je end_strlen
        add rax, 1
        add rdi, 1
        jmp start_strlen
    end_strlen:
        leave
        ret

; ---------------------------------------------

strchr:
    push rbp
    mov rbp, rsp

    start_strchr:
        cmp byte [rdi], 0
        je end_of_lign
        cmp byte [rdi], sil
        je end_strchr
        add rdi, 1
        jmp start_strchr
    end_of_lign:
        mov rax, 0
        leave
        ret
    end_strchr:
        mov rax, rdi
        leave
        ret

; ---------------------------------------------

memset:
    push rbp
    mov rbp, rsp

    mov rcx, rdi
    start_memset:
        cmp rdx, 0
        je end_memset
        mov byte [rdi], sil
        add rdi, 1
        sub rdx, 1
        jmp start_memset
    end_memset:
        mov rax, rcx
        leave
        ret

; ---------------------------------------------

memcpy:
    push rbp
    mov rbp, rsp

    mov rcx, rdi
    start_memcpy:
        cmp rdx, 0
        je end_memcpy
        mov r8b, byte [rsi]
        mov byte [rdi], r8b
        add rdi, 1
        add rsi, 1
        sub rdx, 1
        jmp start_memcpy
    end_memcpy:
        mov rax, rcx
        leave
        ret

; ---------------------------------------------

strcmp:
    push rbp
    mov rbp, rsp

    mov r8, 0
    mov r9, 0
    start_strcmp:
        cmp byte [rdi], 0
        je verify_next_param_strcmp
    continue_strcmp:
        mov r8b, byte [rsi]
        cmp byte [rdi], r8b
        jne end_strcmp
        add rdi, 1
        add rsi, 1
        jmp start_strcmp
    verify_next_param_strcmp:
        cmp byte [rsi], 0
        je exit_error_strcmp
        jmp continue_strcmp
    exit_error_strcmp:
        mov rax, 0
        leave
        ret
    end_strcmp:
        movzx r9, byte [rdi]
        sub r9, r8
        mov rax, r9
        leave
        ret

; ---------------------------------------------

memmove:
    push rbp
    mov rbp, rsp

    mov rcx, rdi
    mov r8, rdx
    add rsi, rdx
    sub rsi, 1
    start_memmove:
        cmp rdx, 0
        je fill_str
        movzx r9, byte [rsi]
        push r9
        sub rsi, 1
        sub rdx, 1
        jmp start_memmove
    fill_str:
        cmp r8, 0
        je end_memmove
        pop r9
        mov byte [rdi], r9b
        add rdi, 1
        sub r8, 1
        jmp fill_str
    end_memmove:
        mov rax, rcx
        leave
        ret

; ---------------------------------------------

strncmp:
    push rbp
    mov rbp, rsp

    mov r8, 0
    mov r9, 0
    start_strncmp:
        cmp rdx, 0
        je end_zero
        mov r8b, byte [rsi]
        cmp byte [rdi], r8b
        jne end_strncmp
        add rdi, 1
        add rsi, 1
        sub rdx, 1
        jmp start_strncmp
    end_zero:
        mov rax, 0
        leave
        ret
    end_strncmp:
        movzx r9, byte [rdi]
        sub r9, r8
        mov rax, r9
        leave
        ret

; ---------------------------------------------

strcasecmp:
    push rbp
    mov rbp, rsp

    mov r8, 0
    mov r9, 0
    start_strcasecmp:
         cmp byte [rdi], 0
         je verify_next_param_strcasecmp
    continue_strcasecmp:
        mov r8b, byte [rsi]
        jmp set_cara_maj
    verify_second_strcasecmp:
        mov r9b, byte [rdi]
        jmp set_cara_maj4
    continue_my_strcasecmp:
        cmp r9b, r8b
        jne end_strcasecmp
        add rdi, 1
        add rsi, 1
        jmp start_strcasecmp

    set_cara_maj:
        cmp r8b, 96
        ja set_cara_maj2
        jmp verify_second_strcasecmp
    set_cara_maj2:
        cmp r8b, 123
        jb set_cara_maj3
        jmp verify_second_strcasecmp
    set_cara_maj3:
        sub r8b, 32
        jmp verify_second_strcasecmp

    set_cara_maj4:
        cmp r9b, 96
        ja set_cara_maj5
        jmp continue_my_strcasecmp
    set_cara_maj5:
        cmp r9b, 123
        jb set_cara_maj6
        jmp continue_my_strcasecmp
    set_cara_maj6:
        sub r9b, 32
        jmp continue_my_strcasecmp

    verify_next_param_strcasecmp:
         cmp byte [rsi], 0
         je exit_error_strcasecmp
         jmp continue_strcasecmp
    exit_error_strcasecmp:
         mov rax, 0
         leave
         ret
    end_strcasecmp:
        movzx r9, byte [rdi]
        sub r9, r8
        mov rax, r9
        leave
        ret

; ---------------------------------------------


rindex:
    push rbp
    mov rbp, rsp

    mov rax, 0
    start_rindex:
        cmp byte [rdi], 0
        je end_rindex
        cmp byte [rdi], sil
        je stock_new_pos
    continue_rindex:
        add rdi, 1
        jmp start_rindex
    stock_new_pos:
        mov rax, rdi
        jmp continue_rindex
    end_rindex:
        leave
        ret

; -------------------------------------

strstr:
    push rbp
    mov rbp, rsp

    mov r8, rdi
    mov rdi, rsi
    mov rsi, r8

    mov r8, rdi
    call strlen
    mov r12, rax
    mov rdi, r8

    mov r10, rdi
    mov r11, rsi
    start_strstr:

        mov r11, rsi
        mov rdi, r10
        mov rdx, r12

        call strncmp
        mov rsi, r11
        cmp rax, 0
        je end_strstr
        cmp byte [rsi], 0
        je end_error_strstr
        add rsi, 1
        jmp start_strstr
    end_error_strstr:
        mov rax, 0
        leave
        ret
    end_strstr:
        mov rax, rsi
        leave
        ret


; -------------------------------------

strcspn:
    push rbp
    mov rbp, rsp

    mov r8, 0
    start_strcspn:
        cmp byte [rdi], 0
        je end_strcspn
        mov dl, byte [rdi]
        mov r10, rsi
        jmp test_cara_strcspn
    continue_strcspn:
        mov rsi, r10
        add rdi, 1
        add r8, 1
        jmp start_strcspn
    test_cara_strcspn:
        cmp byte [rsi], 0
        je continue_strcspn
        cmp byte [rsi], dl
        je end_valid_strcspn
        add rsi, 1
        jmp test_cara_strcspn
    end_strcspn:
        mov rax, 0
        leave
        ret
    end_valid_strcspn:
        mov rax, r8
        leave
        ret

; ------------------------------------

strpbrk:
    push rbp
    mov rbp, rsp

    start_strpbrk:
        cmp byte [rdi], 0
        je end_strpbrk
        mov dl, byte [rdi]
        mov r10, rsi
        jmp test_cara_strpbrk
    continue_strpbrk:
        mov rsi, r10
        add rdi, 1
        jmp start_strpbrk
    test_cara_strpbrk:
        cmp byte [rsi], 0
        je continue_strpbrk
        cmp byte [rsi], dl
        je end_valid_strpbrk
        add rsi, 1
        jmp test_cara_strpbrk
    end_strpbrk:
        mov rax, 0
        leave
        ret
    end_valid_strpbrk:
        mov rax, rdi
        leave
        ret