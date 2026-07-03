;===========================================================
; RUSH HOUR TAXI GAME - Assembly x86
;===========================================================
; Author: Syeda Ummamah Bilal
; Date: 12 November, 2025 
; Description: A complete taxi game with 4 game modes
;===========================================================

include Irvine32.inc

.stack 100h

.data
    ; Game constants
    GRID_SIZE = 20
    ROAD_CHAR = '.'
    BUILDING_CHAR = '#'
    TAXI_CHAR = 'T'
    PASSENGER_CHAR = 'P'
    DESTINATION_CHAR = 'D'
    CAR_CHAR = 'C'
    OBSTACLE_CHAR = 'O'
    PARKING_CHAR = 'H'    ; H inc lives by cmp with 0 & 3 , and inc score by 10 
    
    
    grid db GRID_SIZE * GRID_SIZE dup(0)
    taxi_x db 0
    taxi_y db 0
    taxi_color db 14  ; Yellow
    score dd 0
    lives db 3
    passengers_collected db 0
    
    ; for passenger data
    passenger_x db 3 dup(0)
    passenger_y db 3 dup(0)
    passenger_dest_x db 3 dup(0)
    passenger_dest_y db 3 dup(0)
    passenger_active db 3 dup(0)
    passenger_delivered db 3 dup(0)
    current_passenger db -1
    
    ; npc
    car_x db 5 dup(0)
    car_y db 5 dup(0)
    car_dx db 5 dup(0)
    car_dy db 5 dup(0)
    
    ; H 
    parking_x db 2 dup(0)
    parking_y db 2 dup(0)
    parking_used db 2 dup(0)
    
    ; Player name
    player_name db 50 dup(0)
    
    ; visuals 
    rush_line1 db "  ____  _   _ ____  _   _   _   _  ___  _   _ ____  ",0
    rush_line2 db " |  _ \| | | / ___|| | | | | | | |/ _ \| | | |  _ \ ",0
    rush_line3 db " | |_) | | | \___ \| |_| | | |_| | | | | | | | |_) |",0
    rush_line4 db " |  _ <| |_| |___) |  _  | |  _  | |_| | |_| |  _ < ",0
    rush_line5 db " |_| \_\\___/|____/|_| |_| |_| |_|\___/ \___/|_| \_\",0
    
    taxi_line1 db "  _____  _    __  __ ___    ____    _    __  __ _____ ",0
    taxi_line2 db " |_   _|/ \   \ \/ /|_ _|  / ___|  / \  |  \/  | ____|",0
    taxi_line3 db "   | | / _ \   \  /  | |  | |  _  / _ \ | |\/| |  _|  ",0
    taxi_line4 db "   | |/ ___ \  /  \  | |  | |_| |/ ___ \| |  | | |___ ",0
    taxi_line5 db "   |_/_/   \_\/_/\_\|___|  \____/_/   \_\_|  |_|_____|",0
    
    main_line1 db "  __  __    _    ___ _   _   __  __ _____ _   _ _   _ ",0
    main_line2 db " |  \/  |  / \  |_ _| \ | | |  \/  | ____| \ | | | | |",0
    main_line3 db " | |\/| | / _ \  | ||  \| | | |\/| |  _| |  \| | | | |",0
    main_line4 db " | |  | |/ ___ \ | || |\  | | |  | | |___| |\  | |_| |",0
    main_line5 db " |_|  |_/_/   \_\___|_| \_| |_|  |_|_____|_| \_|\___/ ",0
    
    win_art1 db " __   _____  _   _  __        _____ _   _ _ ",0
    win_art2 db " \ \ / / _ \| | | | \ \      / /_ _| \ | | |",0
    win_art3 db "  \ V / | | | | | |  \ \ /\ / / | ||  \| | |",0
    win_art4 db "   | || |_| | |_| |   \ V  V /  | || |\  |_|",0
    win_art5 db "   |_| \___/ \___/     \_/\_/  |___|_| \_(_)",0
    
    
    over_art1 db "   ____    _    __  __ _____    _____     _______ ____  ",0
    over_art2 db "  / ___|  / \  |  \/  | ____|  / _ \ \   / / ____|  _ \ ",0
    over_art3 db " | |  _  / _ \ | |\/| |  _|   | | | \ \ / /|  _| | |_) |",0
    over_art4 db " | |_| |/ ___ \| |  | | |___  | |_| |\ V / | |___|  _ < ",0
    over_art5 db "  \____/_/   \_\_|  |_|_____|  \___/  \_/  |_____|_| \_\",0
    
    ; declared some msgs to print 
    score_str db "Score: ",0
    lives_str db "Lives: ",0
    passengers_str db "Passengers: ",0
    player_str db "Player: ",0
    game_title db "RUSH HOUR GAME",0
    menu1 db "1. Start New Game",0
    menu2 db "2. Continue Game",0
    menu3 db "3. Difficulty Level",0
    menu4 db "4. Leaderboard",0
    menu5 db "5. Instructions",0
    menu6 db "6. Quit",0
    
    ; wlcome msgs
    welcome_msg db "WELCOME TO",0
    game_title_big db "RUSH HOUR TAXI GAME",0
    enter_name_msg db "Enter your name: ",0
    press_enter db "Press ENTER to continue...",0
    menu_prompt db "Select option (1-6): ",0
    
    ; instructions
    instructions_title db "==== GAME INSTRUCTIONS ====",0
    instructions1 db "Use arrow keys to move taxi",0
    instructions2 db "Spacebar to pick up/drop passengers",0
    instructions3 db "Avoid obstacles and other cars",0
    instructions4 db "Deliver passengers to green destinations",0
    instructions5 db "Pick up passengers (P) shown in CYAN",0
    instructions6 db "Red taxi: harder, Yellow taxi: easier",0
    instructions7 db "Collect all 3 passengers to win!",0
    instructions8 db "Blue (H) spots heal 1 life (max 3)",0
    
    ; difficlty chng
    difficulty_title db "==== DIFFICULTY LEVEL ====",0
    current_diff db "Current: ",0
    yellow_taxi_txt db "YELLOW TAXI (Easy)",0
    red_taxi_txt db "RED TAXI (Hard)",0
    diff_changed db "Difficulty changed!",0
    
    game_over_msg db "GAME OVER",0
    win_msg db "YOU WIN!",0
    press_any_key db "Press any key to continue",0
    final_score db "Final Score: ",0
    carrying_passenger db "Carrying passenger to destination",0
    no_passenger_msg db "No passenger finding one to pick up",0
    life_restored_msg db "Life restored at parking spot!",0

    newline db 0Dh, 0Ah, 0
    space_line db "                                             ",0

    ; type of bool variable to check game is still running or not 
    game_active db 1

    ; filehandle
    leaderboard_file db "leaderboard.txt",0
    leaderboard_title db "==== TOP 3 LEADERBOARD ====",0
    no_leaderboard_msg db "No leaderboard records found.",0
    leaderboard_header db "Rank  Player                 Score",0
    leaderboard_separator db "----- --------------------- -----",0
    
   
    lb_names db 3 dup(50 dup(0))
    lb_scores dd 3 dup(0)
    lb_count dd 0
    
    ; file handle 
    file_buffer db 1000 dup(0)
    temp_score dd 0
    temp_name db 50 dup(0)

    TREE_CHAR = '@'       ; tree
BOX_CHAR = 'B'        ; box
car_color db 5 dup(0) ; any color other then yellow and red 
tree_x db 10 dup(0)
tree_y db 10 dup(0)
box_x db 10 dup(0)
box_y db 10 dup(0)
hit_passenger_msg db "Hit passenger! -5 points",0


buffer1 BYTE 50 DUP(0)

;music using beeps




.code

PlayBeep PROC
    push eax
    mov al, 7           ; ascii code for beep
    call WriteChar
    pop eax
    ret
PlayBeep ENDP


;made clearscreen proc toreduce redundancy
ClearScreen PROC
    push eax
    push edx
    call Clrscr
    pop edx
    pop eax
    ret
ClearScreen ENDP

;initial page
WelcomeScreen PROC
    push eax
    push edx
    
    call ClearScreen
    
    ; Set pink background with cyan text
    mov eax, cyan + (magenta * 16)
    call SetTextColor
    
    ; Fill screen with bg color
    mov ecx, 25
    mov dh, 0
fill_screen:
    push ecx
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET space_line
    mov ecx, 3
print_spaces:
    call WriteString
    loop print_spaces
    pop ecx
    inc dh
    loop fill_screen
    
    ; printing the block writing rush hour 
    mov eax, yellow + (magenta * 16)
    call SetTextColor
    
    mov dh, 3
    mov dl, 10
    call Gotoxy
    mov edx, OFFSET rush_line1
    call WriteString
    
    mov dh, 4
    mov dl, 10
    call Gotoxy
    mov edx, OFFSET rush_line2
    call WriteString
    
    mov dh, 5
    mov dl, 10
    call Gotoxy
    mov edx, OFFSET rush_line3
    call WriteString
    
    mov dh, 6
    mov dl, 10
    call Gotoxy
    mov edx, OFFSET rush_line4
    call WriteString
    
    mov dh, 7
    mov dl, 10
    call Gotoxy
    mov edx, OFFSET rush_line5
    call WriteString
    
    ; Display TAXI GAME
    mov eax, white + (magenta * 16)
    call SetTextColor
    
    mov dh, 9
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET taxi_line1
    call WriteString
    
    mov dh, 10
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET taxi_line2
    call WriteString
    
    mov dh, 11
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET taxi_line3
    call WriteString
    
    mov dh, 12
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET taxi_line4
    call WriteString
    
    mov dh, 13
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET taxi_line5
    call WriteString
    
    ; Get player name
    mov dh, 16
    mov dl, 26
    call Gotoxy
    mov eax, cyan + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET enter_name_msg
    call WriteString
    
    mov dh, 17
    mov dl, 30
    call Gotoxy
    mov eax, yellow + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET player_name
    mov ecx, 49
    call ReadString
    
    ; Press enter message
    mov dh, 20
    mov dl, 25
    call Gotoxy
    mov eax, yellow + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET press_enter
    call WriteString
    
    call ReadChar
    
    pop edx
    pop eax
    ret
WelcomeScreen ENDP

;printing instrs
ShowInstructions PROC
    call ClearScreen
    
    mov eax, Blue + (magenta * 16)
    call SetTextColor
    
    mov dh, 3
    mov dl, 22
    call Gotoxy
    mov edx, OFFSET instructions_title
    call WriteString
    
    mov dh, 6
    mov dl, 15
    call Gotoxy
    mov eax,yellow + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET instructions1
    call WriteString
    
    mov dh, 7
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET instructions2
    call WriteString
    
    mov dh, 8
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET instructions3
    call WriteString
    
    mov dh, 9
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET instructions4
    call WriteString
    
    mov dh, 10
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET instructions5
    call WriteString
    
    mov dh, 11
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET instructions6
    call WriteString
    
    mov dh, 12
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET instructions7
    call WriteString
    
    mov dh, 13
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET instructions8
    call WriteString
    
    mov dh, 16
    mov dl, 24
    call Gotoxy
    mov eax, Black + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET press_any_key
    call WriteString
    
    call ReadChar
    ret
ShowInstructions ENDP

;showing difficult ans changing it if user press it smthg
;two modes in tot one is easy that is taxi one the other hard the red taxi one 

ShowDifficulty PROC
    call ClearScreen
    
    mov eax, Black + (magenta * 16)
    call SetTextColor
    
    mov dh, 8
    mov dl, 24
    call Gotoxy
    mov edx, OFFSET difficulty_title
    call WriteString
    
    mov dh, 11
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET current_diff
    call WriteString
    
    ; displ curr difficul befor chnging it
    cmp taxi_color, 14
    je show_yellow
    mov eax, red + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET red_taxi_txt
    jmp print_diff
show_yellow:
    mov eax, yellow + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET yellow_taxi_txt
print_diff:
    call WriteString
    
    ;wait for key press bfr chnging difficult
    mov dh, 17
    mov dl, 24
    call Gotoxy
    mov eax, white + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET press_any_key
    call WriteString
    
    call ReadChar
    
    ; chnging difficul
    cmp taxi_color, 14
    jne set_yellow
    mov taxi_color, 12  ; make to red taxi
    jmp diff_done
set_yellow:
    mov taxi_color, 14  ; make to lellow taxi
    
diff_done:
    ; making npc cars extra cars making them brown cause mehtioned in manual that they can be any color except red and yellow 
    mov ecx, 5
    mov esi, 0
init_car_colors:
    mov car_color[esi], 6  ; 6 is brown
    inc esi
    loop init_car_colors
    
    
    call ClearScreen
    
    mov eax, Black + (magenta * 16)
    call SetTextColor
    
    mov dh, 8
    mov dl, 24
    call Gotoxy
    mov edx, OFFSET difficulty_title
    call WriteString
    
    mov dh, 11
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET current_diff
    call WriteString
    
    ; displ new dfficult 
    cmp taxi_color, 14
    je show_new_yellow
    mov eax, red + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET red_taxi_txt
    jmp print_new_diff
show_new_yellow:
    mov eax, yellow + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET yellow_taxi_txt
print_new_diff:
    call WriteString
    
    mov dh, 14
    mov dl, 26
    call Gotoxy
    mov eax, cyan + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET diff_changed
    call WriteString
    
    mov dh, 17
    mov dl, 24
    call Gotoxy
    mov eax, white + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET press_any_key
    call WriteString
    
    call ReadChar
    ret
ShowDifficulty ENDP


; making grid making it 20 cross 20 this was told by sir
InitializeGrid PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov edi, OFFSET grid
    mov ecx, GRID_SIZE * GRID_SIZE
    mov al, ROAD_CHAR
    ;making roads
init_roads:
    mov [edi], al
    inc edi
    loop init_roads
    
   ; how many times building hash to come 
    mov ecx, 90  ;made buildings a lil less because if i made them 35% then with boxes trees and C it looked wwway too congested and had really less spaces for taxi to movefor this porpose made it a lil less 
    mov esi, 0
    

    ;buildings randmizing them 
place_buildings:
    call RandomPosition
    mov ebx, eax
    
    mov al, [grid + ebx]
    cmp al, ROAD_CHAR
    jne skip_building
    
    ; checking for inaccessibility 
    push ebx
    call CheckIfPositionBlocks
    pop ebx
    cmp al, 1
    je skip_building    ; skip if it'd create block area
    
    mov byte ptr [grid + ebx], BUILDING_CHAR
    
skip_building:
    inc esi
    cmp esi, ecx
    jl place_buildings
    
    ; H spots
    mov ecx, 2
    mov esi, 0
place_parking:
    call FindEmptyRoadPosition
    mov bl, al
    mov bh, ah
    
    mov parking_x[esi], bl
    mov parking_y[esi], bh
    mov parking_used[esi], 0
    
    ;putting  H 
    mov eax, 0
    mov al, bh
    mov ebx, GRID_SIZE
    mul ebx
    mov dl, parking_x[esi]
    mov dh, 0
    add eax, edx
    mov byte ptr [grid + eax], PARKING_CHAR
    
    inc esi
    loop place_parking
    
    mov taxi_x, 0
    mov taxi_y, 0
    
    mov ecx, 3
    mov esi, 0
place_passengers:
    call FindEmptyRoadPosition
    mov bl, al
    mov bh, ah
    
    mov passenger_x[esi], bl
    mov passenger_y[esi], bh
    mov passenger_active[esi], 1
    mov passenger_delivered[esi], 0
    
    call FindEmptyRoadPosition
    mov bl, al
    mov bh, ah
    
    mov passenger_dest_x[esi], bl
    mov passenger_dest_y[esi], bh
    
    inc esi
    loop place_passengers
    
    mov ecx, 5
    mov esi, 0
place_cars:
    call FindEmptyRoadPosition
    mov bl, al
    mov bh, ah
    
    mov car_x[esi], bl
    mov car_y[esi], bh
    
    mov eax, 3
    call RandomRange
    dec eax
    mov car_dx[esi], al
    
    mov eax, 3
    call RandomRange
    dec eax
    mov car_dy[esi], al
    
    inc esi
    loop place_cars

     mov ecx, 8
    mov esi, 0
place_trees:
    call FindEmptyRoadPosition
    mov bl, al
    mov bh, ah
    mov tree_x[esi], bl
    mov tree_y[esi], bh
    inc esi
    loop place_trees
    
    ; Place boxes
    mov ecx, 8
    mov esi, 0
place_boxes:
    call FindEmptyRoadPosition
    mov bl, al
    mov bh, ah
    mov box_x[esi], bl
    mov box_y[esi], bh
    inc esi
    loop place_boxes


    ;cmp game loop to see if active or not
    
    mov game_active, 1
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
InitializeGrid ENDP


CheckIfPositionBlocks PROC
    push ebx
    push ecx
    push edx
    push esi
    
    ; convrt linear position to x,y  coordinates
    mov eax, ebx
    xor edx, edx
    mov ecx, GRID_SIZE
    div ecx
    ; eax is y and edx is x
    
    ; check for boundaries not place buildings on the coners 
    cmp edx, 0
    je position_blocks
    cmp edx, 19
    je position_blocks
    cmp eax, 0
    je position_blocks
    cmp eax, 19
    je position_blocks
    
    ; count surrounding buildings in 8 directions 
    xor esi, esi        ; counter for surrounding buildings
    
    ; check for topleft
    mov ecx, ebx
    sub ecx, GRID_SIZE
    dec ecx
    cmp byte ptr [grid + ecx], BUILDING_CHAR
    jne check_top
    inc esi
    
check_top:
    ; check top
    mov ecx, ebx
    sub ecx, GRID_SIZE
    cmp byte ptr [grid + ecx], BUILDING_CHAR
    jne check_top_right
    inc esi
    
check_top_right:
    ; Check topright
    mov ecx, ebx
    sub ecx, GRID_SIZE
    inc ecx
    cmp byte ptr [grid + ecx], BUILDING_CHAR
    jne check_left
    inc esi
    
check_left:
    ; check left
    mov ecx, ebx
    dec ecx
    cmp byte ptr [grid + ecx], BUILDING_CHAR
    jne check_right
    inc esi
    
check_right:
    ; Check right
    mov ecx, ebx
    inc ecx
    cmp byte ptr [grid + ecx], BUILDING_CHAR
    jne check_bottom_left
    inc esi
    
check_bottom_left:
    ; check bot left
    mov ecx, ebx
    add ecx, GRID_SIZE
    dec ecx
    cmp byte ptr [grid + ecx], BUILDING_CHAR
    jne check_bottom
    inc esi
    
check_bottom:
    ; check bot
    mov ecx, ebx
    add ecx, GRID_SIZE
    cmp byte ptr [grid + ecx], BUILDING_CHAR
    jne check_bottom_right
    inc esi
    
check_bottom_right:
    ; check bot-right
    mov ecx, ebx
    add ecx, GRID_SIZE
    inc ecx
    cmp byte ptr [grid + ecx], BUILDING_CHAR
    jne check_count
    inc esi
    
check_count:
    ; if in any case 3 or more surrounding buildings, this'd create a blocked area
    cmp esi, 3
    jge position_blocks
    
    mov al, 0           ; position is fien no issue
    jmp check_done
    
position_blocks:
    mov al, 1           ; pos would block access
    
check_done:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
CheckIfPositionBlocks ENDP





FindEmptyRoadPosition PROC
    push ecx
    push edx
    push esi
    
find_position:
    call RandomPosition
    mov edx, eax
    
    mov cl, [grid + edx]
    cmp cl, ROAD_CHAR
    jne find_position
    cmp cl, PARKING_CHAR
    je find_position
    
    mov eax, edx
    mov ebx, GRID_SIZE
    xor edx, edx
    div ebx
    
    mov bl, dl
    mov bh, al
    
    mov cl, taxi_x
    mov ch, taxi_y
    cmp bl, cl
    jne check_passengers
    cmp bh, ch
    je find_position
    
check_passengers:
    mov ecx, 3
    mov esi, 0
check_passengers_loop:
    cmp passenger_active[esi], 0
    je skip_passenger_check
    
    mov dl, passenger_x[esi]
    mov dh, passenger_y[esi]
    cmp bl, dl
    jne skip_passenger_check
    cmp bh, dh
    je find_position
    
skip_passenger_check:
    inc esi
    loop check_passengers_loop
    
    mov ecx, 5
    mov esi, 0
check_cars_loop:
    mov dl, car_x[esi]
    mov dh, car_y[esi]
    cmp bl, dl
    jne skip_car_check
    cmp bh, dh
    je find_position
    
skip_car_check:
    inc esi
    loop check_cars_loop
    
    mov ecx, 2
    mov esi, 0
check_parking_loop:
    mov dl, parking_x[esi]
    mov dh, parking_y[esi]
    cmp bl, dl
    jne skip_parking_check
    cmp bh, dh
    je find_position
    
skip_parking_check:
    inc esi
    loop check_parking_loop
    
    ; check trees
    mov ecx, 8
    mov esi, 0
check_trees_loop:
    mov dl, tree_x[esi]
    mov dh, tree_y[esi]
    cmp bl, dl
    jne skip_tree_check
    cmp bh, dh
    je find_position
skip_tree_check:
    inc esi
    loop check_trees_loop
    
    ; check  for boxes B
    mov ecx, 8
    mov esi, 0
check_boxes_loop:
    mov dl, box_x[esi]
    mov dh, box_y[esi]
    cmp bl, dl
    jne skip_box_check
    cmp bh, dh
    je find_position
skip_box_check:
    inc esi
    loop check_boxes_loop
    
    mov al, bl
    mov ah, bh
    
    pop esi
    pop edx
    pop ecx
    ret
FindEmptyRoadPosition ENDP


RandomPosition PROC
    mov eax, GRID_SIZE * GRID_SIZE
    call RandomRange
    ret
RandomPosition ENDP



DrawGrid PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    call ClearScreen
    
    mov ecx, GRID_SIZE
    mov esi, 0
    
draw_rows:
    push ecx
    mov ecx, GRID_SIZE
    mov edi, 0
    
draw_columns:
    mov eax, esi
    mov ebx, GRID_SIZE
    mul ebx
    add eax, edi
    
    mov bl, [grid + eax]
    
    movzx eax, taxi_x
    cmp edi, eax
    jne check_passenger_pos
    movzx eax, taxi_y
    cmp esi, eax
    jne check_passenger_pos
    
    mov bl, TAXI_CHAR
    mov eax, yellow + (black * 16)
    cmp taxi_color, 12
    jne set_taxi_color
    mov eax, red + (black * 16)
set_taxi_color:
    jmp draw_char

check_passenger_pos:
    push ecx
    push esi
    push edi
    mov ecx, 3
    xor ebx, ebx
check_passenger_draw:
    cmp passenger_active[ebx], 0
    je next_passenger_draw
    
    movzx eax, passenger_x[ebx]
    cmp edi, eax
    jne next_passenger_draw
    
    movzx eax, passenger_y[ebx]
    cmp esi, eax
    jne next_passenger_draw
    
    mov bl, PASSENGER_CHAR
    mov eax, cyan + (black * 16)
    pop edi
    pop esi
    pop ecx
    jmp draw_char
    
next_passenger_draw:
    inc ebx
    loop check_passenger_draw
    
    mov ecx, 3
    xor ebx, ebx
check_dest_draw:
    cmp passenger_delivered[ebx], 1
    je next_dest_draw
    
    movzx eax, passenger_dest_x[ebx]
    cmp edi, eax
    jne next_dest_draw
    
    movzx eax, passenger_dest_y[ebx]
    cmp esi, eax
    jne next_dest_draw
    
    mov bl, DESTINATION_CHAR
    mov eax, green + (black * 16)
    pop edi
    pop esi
    pop ecx
    jmp draw_char
    
next_dest_draw:
    inc ebx
    loop check_dest_draw
    
    mov ecx, 5
    xor ebx, ebx
check_car_draw:
    movzx eax, car_x[ebx]
    cmp edi, eax
    jne next_car_draw
    
    movzx eax, car_y[ebx]
    cmp esi, eax
    jne next_car_draw
    
    mov bl, CAR_CHAR
    ; using brown color for NPC cars
    mov eax, brown + (black * 16)  ; Brown = 6
    pop edi
    pop esi
    pop ecx
    jmp draw_char
    
next_car_draw:
    inc ebx
    loop check_car_draw
    
    ; check for parking spots i.e H 
    mov ecx, 2
    xor ebx, ebx
check_parking_draw:
    movzx eax, parking_x[ebx]
    cmp edi, eax
    jne next_parking_draw
    
    movzx eax, parking_y[ebx]
    cmp esi, eax
    jne next_parking_draw
    
    mov bl, PARKING_CHAR
    mov eax, blue + (black * 16)
    pop edi
    pop esi
    pop ecx
    jmp draw_char
    
next_parking_draw:
    inc ebx
    loop check_parking_draw
    
    ; puttuing check for trees
    mov ecx, 8
    xor ebx, ebx
check_tree_draw:
    movzx eax, tree_x[ebx]
    cmp edi, eax
    jne next_tree_draw
    movzx eax, tree_y[ebx]
    cmp esi, eax
    jne next_tree_draw
    mov bl, TREE_CHAR
    mov eax, lightgreen + (brown * 16)
    pop edi
    pop esi
    pop ecx
    jmp draw_char
next_tree_draw:
    inc ebx
    loop check_tree_draw
    
    
    mov ecx, 8
    xor ebx, ebx
check_box_draw:
    movzx eax, box_x[ebx]
    cmp edi, eax
    jne next_box_draw
    movzx eax, box_y[ebx]
    cmp esi, eax
    jne next_box_draw
    mov bl, BOX_CHAR
    mov eax, 8 + (black * 16)  ; Gray color
    pop edi
    pop esi
    pop ecx
    jmp draw_char
next_box_draw:
    inc ebx
    loop check_box_draw
    
    pop edi
    pop esi
    pop ecx
    
    mov eax, esi
    mov ebx, GRID_SIZE
    mul ebx
    add eax, edi
    mov bl, [grid + eax]
    
    cmp bl, BUILDING_CHAR
    jne is_road
    mov eax, white + (black * 16)
    jmp draw_char
    
is_road:
    mov eax, white + (black * 16)

draw_char:
    call SetTextColor
    
    push edx
    push eax
    
    mov eax, esi
    mov dh, al
    add dh, 2
    
    mov eax, edi
    mov dl, al
    add dl, 2
    
    call Gotoxy
    
    pop eax
    mov al, bl
    call WriteChar
    pop edx
    
    inc edi
    dec ecx
    cmp ecx, 0
    jne draw_columns
    
    call Crlf
    pop ecx
    inc esi
    dec ecx
    cmp ecx, 0
    jne draw_rows
    
    mov dh, GRID_SIZE + 4
    mov dl, 2
    call Gotoxy
    
    mov eax, magenta + (cyan * 16)
    call SetTextColor
    
    mov edx, OFFSET player_str
    call WriteString
    mov edx, OFFSET player_name
    call WriteString
    call Crlf
    
    mov edx, OFFSET score_str
    call WriteString
    mov eax, score
    call WriteDec
    call Crlf
    
    mov edx, OFFSET lives_str
    call WriteString
    movzx eax, lives
    call WriteDec
    call Crlf
    
    mov edx, OFFSET passengers_str
    call WriteString
    movzx eax, passengers_collected
    call WriteDec
    call Crlf
    
    mov eax, white + (magenta * 16)
    call SetTextColor
    cmp current_passenger, -1
    je no_passenger
    mov edx, OFFSET carrying_passenger
    call WriteString
    jmp passenger_done
no_passenger:
    mov edx, OFFSET no_passenger_msg
    call WriteString
passenger_done:
    call Crlf
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DrawGrid ENDP

CheckParking PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    ; check if taxi is on any parking spot
    mov ecx, 2
    mov esi, 0
    
check_parking_loop:
    ; if this H spot used or not 
    cmp parking_used[esi], 1
    je next_parking_check
    
    ; T on H or not 
    mov al, taxi_x
    cmp al, parking_x[esi]
    jne next_parking_check
    
    mov al, taxi_y
    cmp al, parking_y[esi]
    jne next_parking_check
    
    ; H wont work if lives are 0 (at zero game khatam)
    mov al, lives
    cmp al, 0
    jle next_parking_check  ; no lives game end :p
    
    ; ALWAYS add 10 points when landing on H
    mov eax, score
    add eax, 10
    mov score, eax
    
    ; Inc lives if not already at max (3)
    mov al, lives
    cmp al, 3
    jge mark_spot_used  ; alr at max, don't increase lives
    
    ; inc lifes but can't go above 3
    inc lives
    
mark_spot_used:
    ; Mark this H spot as used so it can't be used again
    mov parking_used[esi], 1
    
    ; display restore msg
    mov dh, GRID_SIZE + 9
    mov dl, 2
    call Gotoxy
    mov eax, green + (black * 16)
    call SetTextColor
    mov edx, OFFSET life_restored_msg
    call WriteString
    
    jmp parking_done
    
next_parking_check:
    inc esi
    loop check_parking_loop
    
parking_done:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
CheckParking ENDP

UpdateGame PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    cmp game_active, 0
    je update_done
    
    call PlayBeep
    call CheckParking      ; check for parking spot healing
    call CheckCollisions
    call CheckPassengerInteraction
    
update_done:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
UpdateGame ENDP

CheckCollisions PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    ; check for tree collisions
    mov ecx, 8
    mov esi, 0
check_tree_collision:
    mov al, taxi_x
    cmp al, tree_x[esi]
    jne next_tree_check
    mov al, taxi_y
    cmp al, tree_y[esi]
    jne next_tree_check
    
    ; Tree collision diff penalties based on taxi color
    cmp taxi_color, 12
    jne yellow_tree_hit
    
    ; red taxi hits tree then -2 points
    mov eax, score
    cmp eax, 2
    jl red_tree_zero
    sub eax, 2
    jmp tree_score_done
red_tree_zero:
    mov eax, 0
    jmp tree_score_done
    
yellow_tree_hit:
    ; yellow taxi hits tree -4 points
    mov eax, score
    cmp eax, 4
    jl yellow_tree_zero
    sub eax, 4
    jmp tree_score_done
yellow_tree_zero:
    mov eax, 0
    
tree_score_done:
    mov score, eax
    jmp handle_lives_loss
    
next_tree_check:
    inc esi
    loop check_tree_collision
    
    ; check B collisionss
    mov ecx, 8
    mov esi, 0
check_box_collision:
    mov al, taxi_x
    cmp al, box_x[esi]
    jne next_box_check
    mov al, taxi_y
    cmp al, box_y[esi]
    jne next_box_check
    
    ; same penalties as abv
    cmp taxi_color, 12
    jne yellow_box_hit
    
    ; red taxi hits box -2 points
    mov eax, score
    cmp eax, 2
    jl red_box_zero
    sub eax, 2
    jmp box_score_done
red_box_zero:
    mov eax, 0
    jmp box_score_done
    
yellow_box_hit:
    ; yellow taxi hits box -4 points
    mov eax, score
    cmp eax, 4
    jl yellow_box_zero
    sub eax, 4
    jmp box_score_done
yellow_box_zero:
    mov eax, 0
    
box_score_done:
    mov score, eax
    jmp handle_lives_loss
    
next_box_check:
    inc esi
    loop check_box_collision
    
    ; Check car collisions
    mov ecx, 5
    mov esi, 0
check_cars_collision:
    mov al, taxi_x
    cmp al, car_x[esi]
    jne next_car_check
    mov al, taxi_y
    cmp al, car_y[esi]
    jne next_car_check
    
    ; car collision diff penalties based on taxi color
    cmp taxi_color, 12
    jne yellow_car_hit
    
    ; red taxi hits car -3 points
    mov eax, score
    cmp eax, 3
    jl red_car_zero
    sub eax, 3
    jmp car_score_done
red_car_zero:
    mov eax, 0
    jmp car_score_done
    
yellow_car_hit:
    ; yellow taxi hits car -2 points
    mov eax, score
    cmp eax, 2
    jl yellow_car_zero
    sub eax, 2
    jmp car_score_done
yellow_car_zero:
    mov eax, 0
    
car_score_done:
    mov score, eax
    jmp handle_lives_loss
    
next_car_check:
    inc esi
    loop check_cars_collision
    
    ; Check building collision
    mov eax, 0
    mov al, taxi_y
    mov ebx, GRID_SIZE
    mul ebx
    mov bl, taxi_x
    mov bh, 0
    add eax, ebx
    
    mov cl, [grid + eax]
    cmp cl, BUILDING_CHAR
    jne no_collision
    
    ; building collisions same as abv
    cmp taxi_color, 12
    jne yellow_building_hit
    
    ; red taxi hits building -2 points
    mov eax, score
    cmp eax, 2
    jl red_building_zero
    sub eax, 2
    jmp building_score_done
red_building_zero:
    mov eax, 0
    jmp building_score_done
    
yellow_building_hit:
    ; yellow taxi hits building -4 points
    mov eax, score
    cmp eax, 4
    jl yellow_building_zero
    sub eax, 4
    jmp building_score_done
yellow_building_zero:
    mov eax, 0
    
building_score_done:
    mov score, eax

handle_lives_loss:
    dec lives
    cmp lives, 0
    jle game_over_collision

collision_handled:
    mov taxi_x, 0
    mov taxi_y, 0

no_collision:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
    
game_over_collision:
    mov game_active, 0
    call GameOverScreen
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
CheckCollisions ENDP



CheckPassengerInteraction PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    movzx eax, current_passenger
    cmp al, 255
    jne check_dropoff
    
    mov ecx, 3
    mov esi, 0
check_pickup_loop:
    cmp passenger_active[esi], 0
    je next_passenger_check
    cmp passenger_delivered[esi], 1
    je next_passenger_check
    
    mov al, taxi_x
    mov bl, passenger_x[esi]
    cmp al, bl
    jne next_passenger_check
    
    mov al, taxi_y
    mov bl, passenger_y[esi]
    cmp al, bl
    jne next_passenger_check
    
    ;p picked up
    mov eax, esi
    mov current_passenger, al
    mov passenger_active[esi], 0
    jmp interaction_done
    
next_passenger_check:
    inc esi
    loop check_pickup_loop
    jmp interaction_done
    
check_dropoff:
    movzx esi, current_passenger
    
    cmp esi, 3
    jae interaction_done
    
    mov al, taxi_x
    mov bl, passenger_dest_x[esi]
    cmp al, bl
    jne interaction_done
    
    mov al, taxi_y
    mov bl, passenger_dest_y[esi]
    cmp al, bl
    jne interaction_done
    
    mov passenger_delivered[esi], 1
    
    mov eax, score
    add eax, 10
    mov score, eax
    
    mov al, passengers_collected
    inc al
    mov passengers_collected, al
    
    mov current_passenger, 255
    
    cmp al, 3
    jge level_complete
    jmp interaction_done
    
level_complete:
    mov game_active, 0
    call LevelCompleteScreen
    
interaction_done:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
CheckPassengerInteraction ENDP

GameLoop PROC
    push eax
    
    call DrawGrid
    
game_loop:
    cmp game_active, 0
    je game_end
    
    call ReadChar
    
    cmp al, 27
    je game_end
    
    cmp ah, 48h
    je move_up
    cmp ah, 50h
    je move_down
    cmp ah, 4Bh
    je move_left
    cmp ah, 4Dh
    je move_right
    cmp al, ' '
    je interact
    
    call DrawGrid
    jmp game_loop
    
move_up:
    mov al, taxi_y
    cmp al, 0
    je redraw
    dec taxi_y
    jmp update
    
move_down:
    mov al, taxi_y
    cmp al, GRID_SIZE - 1
    je redraw
    inc taxi_y
    jmp update
    
move_left:
    mov al, taxi_x
    cmp al, 0
    je redraw
    dec taxi_x
    jmp update
    
move_right:
    mov al, taxi_x
    cmp al, GRID_SIZE - 1
    je redraw
    inc taxi_x
    jmp update
    
interact:
    jmp update
    
update:
    call UpdateGame
    
redraw:
    call DrawGrid
    jmp game_loop
    
game_end:
    pop eax
    ret
GameLoop ENDP

GameOverScreen PROC
    call ClearScreen
    
    ; pink bg
    mov eax, yellow + (magenta * 16)
    call SetTextColor
    
    ; filled screen with bg color
    mov ecx, 25
    mov dh, 0
fill_over_screen:
    push ecx
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET space_line
    mov ecx, 3
print_over_spaces:
    call WriteString
    loop print_over_spaces
    pop ecx
    inc dh
    loop fill_over_screen
    
    mov eax, red + (magenta * 16)
    call SetTextColor
    
    ;hardcoding vals to be more prcise with placemnets 
    mov dh, 6
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET over_art1
    call WriteString
    
    mov dh, 7
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET over_art2
    call WriteString
    
    mov dh, 8
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET over_art3
    call WriteString
    
    mov dh, 9
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET over_art4
    call WriteString
    
    mov dh, 10
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET over_art5
    call WriteString
    ;hardcoding vals just to be as accurate with the placement of stuff as possible
    ; display final score
    mov dh, 14
    mov dl, 28
    call Gotoxy
    mov eax, yellow + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET final_score
    call WriteString
    mov eax, score
    call WriteDec
    
    ; update leaderboard
    call UpdateLeaderboard
    
    ; press any key
    mov dh, 18
    mov dl, 24
    call Gotoxy
    mov eax, white + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET press_any_key
    call WriteString
    
    call ReadChar
    ret
GameOverScreen ENDP

LevelCompleteScreen PROC
    call ClearScreen
    
    mov eax, yellow + (magenta * 16)
    call SetTextColor
    
    ; fill screen with bg color
    mov ecx, 25
    mov dh, 0
fill_win_screen:
    push ecx
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET space_line
    mov ecx, 3
print_win_spaces:
    call WriteString
    loop print_win_spaces
    pop ecx
    inc dh
    loop fill_win_screen
    
    ; win box chars
    mov eax, green + (magenta * 16)
    call SetTextColor
    
    mov dh, 7
    mov dl, 12
    call Gotoxy
    mov edx, OFFSET win_art1
    call WriteString
    
    mov dh, 8
    mov dl, 12
    call Gotoxy
    mov edx, OFFSET win_art2
    call WriteString
    
    mov dh, 9
    mov dl, 12
    call Gotoxy
    mov edx, OFFSET win_art3
    call WriteString
    
    mov dh, 10
    mov dl, 12
    call Gotoxy
    mov edx, OFFSET win_art4
    call WriteString
    
    mov dh, 11
    mov dl, 12
    call Gotoxy
    mov edx, OFFSET win_art5
    call WriteString
    
    ; display congrats msg
    mov dh, 14
    mov dl, 20
    call Gotoxy
    mov eax, yellow + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET final_score
    call WriteString
    mov eax, score
    call WriteDec
    
    ; update leaderboard
    call UpdateLeaderboard
    
    ; press any key
    mov dh, 18
    mov dl, 24
    call Gotoxy
    mov eax, white + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET press_any_key
    call WriteString
    
    call ReadChar
    ret
LevelCompleteScreen ENDP



; file handle stuff 
StrToInt PROC
    push ebx
    push ecx
    push edx
    push esi
    
    xor eax, eax        ; result = 0
    xor ebx, ebx        ; temp for digit
    mov esi, edx        ; esi points to strg
    
next_digit:
    mov bl, [esi]       ; get char
    test bl, bl         ; check for null char
    je done_convert
    cmp bl, 13          ; 
    je done_convert
    cmp bl, 10          ; 
    je done_convert
    cmp bl, ','         ; check for ,
    je done_convert
    
    cmp bl, '0'         ; check if valid digit
    jb done_convert
    cmp bl, '9'
    ja done_convert
    
    sub bl, '0'         ;covert ascii to num
   push edx           
mov edx, 10         
push ebx           
mov ebx, edx        
mul ebx            
pop ebx             
pop edx 
    add eax, ebx        ; additon for the digit
    inc esi             ; next char
    jmp next_digit
    ;proper behavior can be seen in videos attched 
done_convert:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
StrToInt ENDP

; convert number in EAX to string in buffer1
NumToStr PROC
    push ebx
    push ecx
    push edx
    push edi
    
    mov edi, OFFSET buffer1
    add edi, 49         ; points to the end of the buffer  end of buffer
    mov byte ptr [edi], 0   ; null terminate the one we put 
    dec edi
    
    mov ebx, 10
    mov ecx, 0          ; digit count
    
    cmp eax, 0
    jne convert_digits
    
    ; special case for zero
    mov byte ptr [edi], '0'
    dec edi
    inc ecx
    jmp finish_convert
    
convert_digits:
    xor edx, edx
    div ebx             ; EAX = EAX / 10, EDX = remainder 
    add dl, '0'         ; convert to ascii val
    mov [edi], dl
    dec edi
    inc ecx
    test eax, eax
    jnz convert_digits
    
finish_convert:
    inc edi             ; point to first digi
    mov eax, edi        ; return ptr in EAX
    
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret
NumToStr ENDP

; Sort the leaderboard in descend order
SortLeaderboard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov ecx, 3          ; outer loop 3 passes
    
outer_loop:
    push ecx
    mov ebx, 0          ; inner loop count saving
    
inner_loop:
    cmp ebx, 2          ; cmp up to second-to-last entry
    jge outer_continue
    
    ; comparing scores for putting in file
    mov eax, ebx
    mov edx, 4
    mul edx
    lea esi, lb_scores
    add esi, eax
    mov eax, [esi]      ; curr score
    mov edi, [esi+4]    ; next score
    
    cmp eax, edi
    jge no_swap         ; if curr >= next that means no swap neededd
    
    ; Swap scores
    mov [esi], edi
    mov [esi+4], eax
    
    ; Swap names
    push ebx
    mov eax, ebx
    mov edx, 50
    mul edx
    lea esi, lb_names
    add esi, eax
    lea edi, temp_name
    mov ecx, 50
               ; copy curr name to temp

  copyl1:
  mov al,[esi]
  mov [edi],al
  inc esi
  inc edi
  dec ecx
  jnz copyl1
    
    pop ebx
    push ebx
    
    ; copy next name to currt pos
    mov eax, ebx
    inc eax
    mov edx, 50
    mul edx
    lea esi, lb_names
    add esi, eax
    
    mov eax, ebx
    mov edx, 50
    mul edx
    lea edi, lb_names
    add edi, eax
    mov ecx, 50
    copyl2:
  mov al,[esi]
  mov [edi],al
  inc esi
  inc edi
  dec ecx
  jnz copyl2
    
    ; copy temp to next pos
    pop ebx
    push ebx
    mov eax, ebx
    inc eax
    mov edx, 50
    mul edx
    lea edi, lb_names
    add edi, eax
    lea esi, temp_name
    mov ecx, 50
    copyl3:
  mov al,[esi]
  mov [edi],al
  inc esi
  inc edi
  dec ecx
  jnz copyl3
    
    pop ebx
    ; no swapping to do for if we did got any higher score pep
no_swap:
    inc ebx
    jmp inner_loop
    
outer_continue:
    pop ecx
    dec ecx              ; dec countr
    cmp ecx, 0          ;  condition to check for if doen
    jne outer_loop      ;  contin if not zero
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
SortLeaderboard ENDP

; load leaderboard from file  remving commas and doing str to num
LoadLeaderboard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    
    ;making lb arrays emptys
   
   mov edi, offset lb_names
mov ecx, 150
xor al, al
clear_names_loop:
    mov [edi], al     ; Store 0 at current position
    inc edi           ; Move to next byte
    loop clear_names_loop 
    
    mov edi, OFFSET lb_scores
    mov ecx, 3
    xor eax, eax
clear_scores_loop:
    mov [edi], eax     ; Store 0 (4 bytes)
    add edi, 4         ; Next dword
    loop clear_scores_loop


    mov lb_count, 0
    
    ; open file
    lea edx, leaderboard_file
    call OpenInputFile
    cmp eax, INVALID_HANDLE_VALUE
    je load_failed
    
    mov ebx, eax        ; save file handle
    
    ; Clear file buffer
    mov edi, offset file_buffer
    mov ecx, 1000
    xor al, al
    clearr:
    mov [edi],al
    inc edi
    dec ecx
    jnz clearr

    
    ; Read file
    mov eax, ebx
    lea edx, file_buffer
    mov ecx, 999
    call ReadFromFile
    
    push eax            ; save bytes read
    mov eax, ebx
    call CloseFile
    pop eax
    
    cmp eax, 0
    jle load_failed
    
    ; Parse buffer
    lea esi, file_buffer
    xor edi, edi        ; entry countr
    
parse_entry:
    cmp edi, 3
    jge parse_done
    
    mov al, [esi]
    cmp al, 0
    je parse_done
    cmp al, 13    ;carriage ret   
    je skip_char
    cmp al, 10   ;end of line 
    je skip_char
    
    ; read name
    push edi
    mov eax, edi
    mov ebx, 50
    mul ebx
    mov edi, eax
    lea edi, [lb_names + edi]
    
read_name:
    mov al, [esi]
    cmp al, ','
    je name_done
    cmp al, 0
    je parse_done_pop
    cmp al, 13
    je parse_done_pop
    cmp al, 10
    je parse_done_pop
    
    mov [edi], al
    inc esi
    inc edi
    jmp read_name
    
name_done:
    mov byte ptr [edi], 0
    inc esi             ; skip ,
    pop edi
    
    ; Read score
    mov edx, esi
    call StrToInt       ; convert score str to num
    
    push edi
    mov ebx, edi
    mov edi, 4
    mov ecx, ebx
    mov ebx, ecx
    mul edi
    mov edi, eax
    mov eax, ecx
    mov ebx, 4
    mul ebx
    mov ecx, eax
    pop edi
    
    push edi
    push eax
    mov eax, edi
    mov ebx, 4
    mul ebx
    lea edi, lb_scores
    add edi, eax
    pop eax
    
    ; get score val again
    push esi
    mov edx, esi
    call StrToInt
    mov [edi], eax
    pop esi
    pop edi
    
    
    ; moving to new line
skip_line:
    mov al, [esi]
    cmp al, 0
    je parse_done
    inc esi
    cmp al, 10
    jne skip_line
    
    inc edi
    jmp parse_entry
    
skip_char:
    inc esi
    jmp parse_entry
    
parse_done_pop:
    pop edi
    inc edi
    
parse_done:
    mov lb_count, edi
    jmp load_exit
    
load_failed:
    mov lb_count, 0
    
load_exit:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
LoadLeaderboard ENDP

; Save leaderboard to file addiding commas and doing num to str asw
SaveLeaderboard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Open/create file
    lea edx, leaderboard_file
    call CreateOutputFile
    cmp eax, INVALID_HANDLE_VALUE
    je save_failed
    
    mov ebx, eax        ; Save file handle
    
    ; Clear file buffer
    mov edi, OFFSET file_buffer
    mov ecx, 1000
    xor al, al
clearbuff:
    mov [edi], al
    inc edi
    loop clearbuff
    
    ; building 
    mov edi, OFFSET file_buffer
    xor esi, esi
    
write_entry:
    cmp esi, lb_count
    jge write_file
    cmp esi, 3
    jge write_file
    
    ; Write name
    push esi
    mov eax, esi
    mov ecx, 50
    mul ecx
    lea edx, lb_names
    add edx, eax
    
copy_name:
    mov al, [edx]
    cmp al, 0
    je name_copied
    mov [edi], al
    inc edx
    inc edi
    jmp copy_name
    
name_copied:
    ;put comma
    mov byte ptr [edi], ','
    inc edi
    
    ; writingw scoreee
    pop esi
    push esi
    mov eax, esi
    mov ecx, 4
    mul ecx
    lea edx, lb_scores
    add edx, eax
    mov eax, [edx]
    
    call NumToStr       ; conversion
    
    ; copy score str
    mov edx, eax
copy_score:
    mov al, [edx]
    cmp al, 0
    je score_copied
    mov [edi], al
    inc edx
    inc edi
    jmp copy_score
    
score_copied:
    ; newl score
    mov byte ptr [edi], 13
    inc edi
    mov byte ptr [edi], 10
    inc edi
    
    pop esi
    inc esi
    jmp write_entry
    
write_file:
    ; calc length
    mov byte ptr [edi], 0
    lea eax, file_buffer
    sub edi, eax
    mov ecx, edi
    
    ; wite in file
    mov eax, ebx
    lea edx, file_buffer
    call WriteToFile
    
    ; close file
    mov eax, ebx
    call CloseFile
    
save_failed:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
SaveLeaderboard ENDP


; update with new leaderboard scor 
UpdateLeaderboard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; load alr present leaderboard 
    call LoadLeaderboard
    
    
    ; where to put score 
    xor esi, esi
    mov eax, score
    
find_insert_pos:
    cmp esi, lb_count
    jge insert_at_pos
    cmp esi, 3
    jge check_replace
    
    push esi
    mov eax, esi
    mov ebx, 4
    mul ebx
    lea edx, lb_scores
    add edx, eax
    mov eax, score
    mov ecx, [edx]
    pop esi
    
    cmp eax, ecx
    jg insert_at_pos
    
    inc esi
    jmp find_insert_pos
    
check_replace:
    ; If we have 3 entries and new score doesnt make top 3, don't add
    cmp lb_count, 3
    jge update_done
    
insert_at_pos:
    ; Shift entries down
    mov edi, lb_count
    cmp edi, 3
    jl shift_entries
    mov edi, 2          ; keeping only top 3 top 10 was hard for me to handle 
    
shift_entries:
    cmp edi, esi
    jle insert_new
    
    ; shift score
    push esi
    mov eax, edi
    dec eax
    mov ebx, 4
    mul ebx
    lea edx, lb_scores
    add edx, eax
    mov ecx, [edx]
    
    mov eax, edi
    mov ebx, 4
    mul ebx
    lea edx, lb_scores
    add edx, eax
    mov [edx], ecx
    pop esi
    
    ; shift name 
    push esi
    push edi
    
    mov eax, edi
    dec eax
    mov ebx, 50
    mul ebx
    lea esi, lb_names
    add esi, eax
    
    mov eax, edi
    mov ebx, 50
    mul ebx
    lea edi, lb_names
    add edi, eax
    
    mov ecx, 50

    copyl4:
  mov al,[esi]
  mov [edi],al
  inc esi
  inc edi
  dec ecx
  jnz copyl4
    
    pop edi
    pop esi
    
    dec edi
    jmp shift_entries
    
insert_new:
    ; putting new name
    mov eax, esi
    mov ebx, 4
    mul ebx
    lea edx, lb_scores
    add edx, eax
    mov eax, score
    mov [edx], eax
    
    ; putting new name
    push esi
    mov eax, esi
    mov ebx, 50
    mul ebx
    lea edi, lb_names
    add edi, eax
    lea esi, player_name
    mov ecx, 50
   copyl5:
  mov al,[esi]
  mov [edi],al
  inc esi
  inc edi
  dec ecx
  jnz copyl5
    pop esi
    
    ; updating cnt 
    mov eax, lb_count
    cmp eax, 3
    jge save_board
    inc eax
    mov lb_count, eax
    
save_board:
    ; save to file
    call SaveLeaderboard
    
update_done:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
UpdateLeaderboard ENDP

; display leaderboard 
;  video attched cearly shows how the leaderboard works and sorts accordingy
ShowLeaderboard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    call ClearScreen
    call LoadLeaderboard
    
    ; set bg
    mov eax, cyan + (magenta * 16)
    call SetTextColor
    
    ; fill scre
    mov ecx, 25
    mov dh, 0
fill_lb_screen:
    push ecx
    mov dl, 0
    call Gotoxy
    lea edx, space_line
    mov ecx, 3
print_lb_spaces:
    call WriteString
    loop print_lb_spaces
    pop ecx
    inc dh
    loop fill_lb_screen
    
    ; title Display
    mov dh, 3
    mov dl, 22
    call Gotoxy
    mov eax, yellow + (magenta * 16)
    call SetTextColor
    lea edx, leaderboard_title
    call WriteString
    
    ; check if nthg is there
    cmp lb_count, 0
    jne show_records
    
    mov dh, 8
    mov dl, 20
    call Gotoxy
    mov eax, white + (magenta * 16)
    call SetTextColor
    lea edx, no_leaderboard_msg
    call WriteString
    jmp lb_done
    
show_records:
    ; Display header
    mov dh, 6
    mov dl, 10
    call Gotoxy
    mov eax, white + (magenta * 16)
    call SetTextColor
    lea edx, leaderboard_header
    call WriteString
    
    mov dh, 7
    mov dl, 10
    call Gotoxy
    lea edx, leaderboard_separator
    call WriteString
    
    ; dsiplay at next row
    xor esi, esi
    mov dh, 8           ; Start at row 8
    
display_entry:
    cmp esi, lb_count
    jge lb_done
    cmp esi, 3
    jge lb_done
    
    ; setting curspr
    mov dl, 12
    call Gotoxy
    
    mov eax, white + (magenta * 16)
    call SetTextColor
    
    ; display rank
    mov eax, esi
    inc eax
    call WriteDec
    
    ; aading spaces and .
    mov al, '.'
    call WriteChar
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    
    ; display
    push esi
    mov eax, esi
    mov ebx, 50
    mul ebx
    lea edx, lb_names
    add edx, eax
    call WriteString
    pop esi
    
    ; put cursor to the point you last places the score
    mov dl, 40
    call Gotoxy
    
    ; disply score
    push esi
    push edx
    mov eax, esi
    mov ebx, 4
    mul ebx
    lea edx, lb_scores
    add edx, eax
    mov eax, [edx]
    call WriteDec
    pop edx
    pop esi
    
    ; going to next line 
    inc dh
    inc esi
    call Crlf
    jmp display_entry
    
lb_done:
    mov dh, 20
    mov dl, 24
    call Gotoxy
    mov eax, white + (magenta * 16)
    call SetTextColor
    lea edx, press_any_key
    call WriteString
    
    call ReadChar
    
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
ShowLeaderboard ENDP


MainMenu PROC
    push edx
    
menu_loop:
    call ClearScreen
    
    ; pink bg
    mov eax, cyan + (magenta * 16)
    call SetTextColor
    
    ; filling bg with color
    mov ecx, 25
    mov dh, 0
fill_menu_screen:
    push ecx
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET space_line
    mov ecx, 3
print_menu_spaces:
    call WriteString
    loop print_menu_spaces
    pop ecx
    inc dh
    loop fill_menu_screen
    
    ; main menu box chars
    mov eax, yellow + (magenta * 16)
    call SetTextColor
    
    mov dh, 2
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET main_line1
    call WriteString
    
    mov dh, 3
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET main_line2
    call WriteString
    
    mov dh, 4
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET main_line3
    call WriteString
    
    mov dh, 5
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET main_line4
    call WriteString
    
    mov dh, 6
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET main_line5
    call WriteString
    
    ; display menu opts
    mov dh, 9
    mov dl, 28
    call Gotoxy
    mov eax, white + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET menu1
    call WriteString
    
    mov dh, 10
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET menu2
    call WriteString
    
    mov dh, 11
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET menu3
    call WriteString
    
    mov dh, 12
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET menu4
    call WriteString
    
    mov dh, 13
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET menu5
    call WriteString
    
    mov dh, 14
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET menu6
    call WriteString
    
    ;hardcode vals to be precise 
    mov dh, 16
    mov dl, 25
    call Gotoxy
    mov eax, cyan + (magenta * 16)
    call SetTextColor
    mov edx, OFFSET menu_prompt
    call WriteString
    
    call ReadChar
    ;taking user input and proceeding game acc


    cmp al, '1'
    je start_new_game
    cmp al, '2'
    je continue_game
    cmp al, '3'
    je difficulty_menu
    cmp al, '4'
    je show_leaderboard
    cmp al, '5'
    je show_instructions
    cmp al, '6'
    je quit_program
    
    jmp menu_loop
    
    ;initial scor is zero lives are 3 thats complexity
start_new_game:
    call InitializeGrid
    mov score, 0
    mov lives, 3
    mov passengers_collected, 0
    mov current_passenger, -1
    call GameLoop
    jmp menu_loop
    
    ; if in between player esc thn if it presses continue game it takes it exaclty whre is left and let it resume
continue_game:
    cmp game_active, 0
    je menu_loop
    call GameLoop
    jmp menu_loop
    
    ;difficult levels red is hard yellow is easy both differ in reduction of oints upon collisons with the obstacles 
difficulty_menu:
    call ShowDifficulty
    jmp menu_loop
    
show_leaderboard:
    call ShowLeaderboard
    jmp menu_loop
    
    ;intructions to tell the player 
show_instructions:
    call ShowInstructions
    jmp menu_loop
    
    ; ending game 
quit_program:
    pop edx
    ret
MainMenu ENDP

main PROC
    call Randomize  ; random num generator without this RnadomRange 'd produce same sequence of grid and related components 
    call LoadLeaderboard
    call WelcomeScreen
    call MainMenu
    exit
main ENDP

END main
;explained a somestuff side by side with code. detailed code explanation along with screenshots have been added in my report