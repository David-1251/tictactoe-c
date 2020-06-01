// Noughts & Crosses


#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void game_mode(char* opponent);
char choose_player(char* player_char_ptr, char* cpu_char_ptr);
void display_board(char *raw_data);
int evaluate_win(char *raw_data, char player_char, char cpu_char, char* game_stats, char* opponent);
int is_game_won(char *raw_data, char player);
void show_win_details(int win_value, char player);
char player_turn(char *raw_data, char player_char);
int cpu_turn(char *raw_data, char player_char, char cpu_char);
int find_move(char *raw_data, char* test_board, char* winning_moves, char player, char depth, char* position);
int select_move(char* raw_data, char* winning_moves, char* cpu_char, char value, char offset);
char game_reset(void);


int main(void) {

    char game_stats[3];
    for(int i = 0; i <=2; ++i) {game_stats[i] = 0;}
    char clear_input_buffer = 0;
    char is_game_active = 1;
    char player_char;
    char cpu_char;
    char is_player_turn;
    char opponent[16] = "               ";

    printf("Welcome to Noughts & Crosses!\n\nVersion 0.6, 26/04/2020\n\n\n");
    game_mode(opponent);

    while(is_game_active) {
        char raw_data[10] = "         ";

        is_player_turn = choose_player(&player_char, &cpu_char);
        printf("\nYou have chosen %c. %s is %c.\n\n", player_char, opponent, cpu_char);
        printf("Board positions:\n[1][2][3]\n[4][5][6]\n[7][8][9]\n\n");
        printf("Starting board:\n");
        display_board(raw_data);
        printf("Try to get three in a row!\n\n");

        while(evaluate_win(raw_data, player_char, cpu_char, game_stats, opponent) == 0) {
            if(is_player_turn) {
                printf("Player 1's move (type a number 1-9): ");
                is_player_turn = player_turn(raw_data, player_char);
            }
            else {
                if(opponent[0] == 'P') {
                    printf("Player 2's move (type a number 1-9): ");
                    player_turn(raw_data, cpu_char);
                    is_player_turn = 1;
                }
                else {
                is_player_turn = cpu_turn(raw_data, player_char, cpu_char);
                }
            }
            display_board(raw_data);
        }
        if(opponent[0] == 'P') {
            printf("Player 1 wins: %d    Player 2 wins: %d    Draws: %d\n\n", game_stats[0], game_stats[1], game_stats[2]);
        }
        else {
            printf("Wins: %d    Losses: %d    Draws: %d\n\n", game_stats[0], game_stats[1], game_stats[2]);
        }
        is_game_active = game_reset();
    }
}


void game_mode(char* opponent) {
    int clear_input_buffer;
    while(*opponent != '1' && *opponent != '2'){
        printf("1) Two-player\n2) Versus computer player\nChoose a game mode (type 1 or 2): ");
        scanf("%c", opponent);
        while ((clear_input_buffer = getchar()) != '\n'
               && clear_input_buffer != EOF) {
            *opponent = 0;
        }
        if(*opponent == '1') {
           strcpy(opponent, "Player 2");
           printf("\nYou have chosen two-player.\n\n");
           return;
        }
        if(*opponent == '2') {
           strcpy(opponent, "Computer player");
           printf("\nYou have chosen versus computer player.\n\n");
           return;
        }
        else {
            printf("Invalid input.\n\n");
        }
    }
}


char choose_player(char* player_char_ptr, char* cpu_char_ptr) {
    int clear_input_buffer;
    *player_char_ptr = 0;
    while(*player_char_ptr != 'O' && *player_char_ptr != 'X'){
        printf("Player 1, choose O or X: ");
        scanf("%c", player_char_ptr);
        while ((clear_input_buffer = getchar()) != '\n'
               && clear_input_buffer != EOF) {
            *player_char_ptr = 0;
        }
        if((*player_char_ptr == 'O') || (*player_char_ptr == 'o') || (*player_char_ptr == '0')) {
           *player_char_ptr = 'O';
           *cpu_char_ptr = 'X';
           return 1;
        }
        else if((*player_char_ptr == 'X') || (*player_char_ptr == 'x')) {
           *player_char_ptr = 'X';
           *cpu_char_ptr = 'O';
           return 0;
        }
        else {
            printf("Invalid input.\n\n");
        }
    }
};


void display_board(char *raw_data) {
    char display_model[] = "[ ][ ][ ]\n[ ][ ][ ]\n[ ][ ][ ]";
    // Iteration variables
    int i, j, k; k = 0;
    for (i = 0; i <= 2; ++i) {
        for(j = 1; j <= 7; j+=3) {
            display_model[(i*10) + j] = raw_data[k++];
        }
    }
    printf("%s\n\n", display_model);
}


int evaluate_win(char *raw_data, char player_char, char cpu_char, char* game_stats, char* opponent) {
    int win_value;
    if(win_value = is_game_won(raw_data, player_char)){
        show_win_details(win_value, player_char);
        if(*opponent=='P') {printf("Congratulations, Player 1!\n\n");}
        else{printf("Congratulations!\n\n");}
        ++game_stats[0];
        return 1;
    }
    if(win_value = is_game_won(raw_data, cpu_char)){
        show_win_details(win_value, cpu_char);
        if(*opponent=='P') {printf("Congratulations, Player 2!\n\n");}
        else{printf("Better luck next time!\n\n");}
        ++game_stats[1];
        return 2;
    }

    int i;
    for(i = 0; i <= 8; ++i) {
        if(raw_data[i] == ' ') {
            return 0;
        }
    }
    printf("Draw!\n\n");
    ++game_stats[2];
    return 3;
}


int is_game_won(char *raw_data, char player) {
    int i;
    //Horizontal wins
    for(i = 0; i <= 6; i+=3) {
        if(raw_data[i] == player && raw_data[i+1] == player
           && raw_data[i+2] == player) {
            return 10+i;
        }
    }
    //Vertical wins
    for(i = 0; i <= 2; ++i) {
        if(raw_data[i] == player && raw_data[i+3] == player
           && raw_data[i+6] == player) {
            return 20+i;
        }
    }
    //Diagonal wins
    if(raw_data[4] == player) {
        if(raw_data[0] == player && raw_data[8] == player) {
            return 31;
        }
        if(raw_data[2] == player && raw_data[6] == player) {
            return 32;
        }
    }
    return 0;
}


void show_win_details(int win_value, char player) {
    switch(win_value) {
        case 0: break;
        case 10 : printf("%c has won! Row 1.\n\n", player); break;
        case 13 : printf("%c has won! Row 2.\n\n", player); break;
        case 16 : printf("%c has won! Row 3.\n\n", player); break;
        case 20 : printf("%c has won! Column 1.\n\n", player); break;
        case 21 : printf("%c has won! Column 2.\n\n", player); break;
        case 22 : printf("%c has won! Column 3.\n\n", player); break;
        case 31 : printf("%c has won! Diagonal 1.\n\n", player); break;
        case 32 : printf("%c has won! Diagonal 2.\n\n", player); break;
        default: printf("Some error occurred.\n\n"); break;
    }
}


char player_turn(char *raw_data, char player_char) {
    int clear_input_buffer;
    int player_move = 0;
    scanf("%d", &player_move);
    while ((clear_input_buffer = getchar()) != '\n'
           && clear_input_buffer != EOF) { }
    if(player_move < 10 && player_move > 0) {
        if(raw_data[player_move - 1] == ' ') {
            raw_data[player_move - 1] = player_char;
            return 0;
        }
        else {printf("Invalid move. That position is occupied.\n\n");}
        return 1;
    }
    else {printf("Invalid input.\n\n");}
    return 1;
}


int cpu_turn(char *raw_data, char player_char, char cpu_char) {
    char test_board[60];
    char winning_moves[60];
    char position[3];
    for(char i = 0; i <= 60; ++i) {winning_moves[i] = 0;}
    printf("Computer player's move: \n");
    // Searching for CPU winning move
    find_move(raw_data, test_board, winning_moves, cpu_char, 0, position);
    find_move(raw_data, &test_board[30], &winning_moves[30], player_char, 0, position);

    // Selecting move in priority order
    if(select_move(raw_data, winning_moves, cpu_char, 1, 0)) {return 1;}
    if(select_move(raw_data, winning_moves, cpu_char, 1, 30)) {return 1;}
    if(select_move(raw_data, winning_moves, cpu_char, 2, 10)) {return 1;}
    if(select_move(raw_data, winning_moves, cpu_char, 2, 40)) {return 1;}
    if(select_move(raw_data, winning_moves, cpu_char, 6, 20)) {return 1;}
    if(select_move(raw_data, winning_moves, cpu_char, 6, 50)) {return 1;}
    if(select_move(raw_data, winning_moves, cpu_char, 1, 10)) {return 1;}
    if(select_move(raw_data, winning_moves, cpu_char, 1, 20)) {return 1;}
    if(select_move(raw_data, winning_moves, cpu_char, 0, 20)) {return 1;}
    return 0;
}


int find_move(char *raw_data, char* test_board, char* winning_moves, char player, char depth, char* position) {
    ++depth;
    strcpy(&test_board[0], raw_data);
    for(position[depth-1] = 0; position[depth-1] <= 8; ++position[depth-1]) {
        if(test_board[position[depth-1]] == ' ') {
            test_board[position[depth-1]] = player;
            if(is_game_won(&test_board[0], player)) {
                ++winning_moves[position[0]];
            }
            if(depth < 3) {
                find_move(&test_board[0], &test_board[10], &winning_moves[10], player, depth, position);
            }
            test_board[position[depth-1]] = ' ';
        }
    }
}


int select_move(char* raw_data, char* winning_moves, char* cpu_char, char value, char offset) {
    for(char i = offset; i <= offset + 8; ++i) {
        if(winning_moves[i] >= value) {
                raw_data[i-offset] = cpu_char;
                return 1;
        }
    }
    if(value==0) {
        for(int k=0; k<=8; ++k) {
            if(raw_data[k]==' ') {
                raw_data[k] = cpu_char;
                return 1;
            }
        }
    }
    return 0;
}


char game_reset(void) {
    char play_again = 1;
    char clear_input_buffer = 0;
    while(play_again) {
        printf("Play again (Y/N)? ");
        scanf("%c", &play_again);
        while((clear_input_buffer = getchar()) != '\n'
               && clear_input_buffer != EOF) {
            play_again = 1;
        }
        if((play_again == 'N') || (play_again == 'n')) {
           return 0;
        }
        else if((play_again == 'Y') || (play_again == 'y')) {
            printf("\n\n\n");
            return 1;
        }
        printf("Invalid input.\n\n");
    }

}
