import { Token, TokenType } from "./token"

class Lexer {
    private input: string;
    private input_pos: number;
    private line_number: number;
    private char_position: number;

    public constructor(input: string) {
        this.input = input;
        this.input_pos = 0;
        this.line_number = 1;
        this.char_position = 0;
    }

    public next_token(): Token {
        this.skip_whitespace();
        switch (this.read_char()) {
            case 'A': return { ttype: TokenType.Ace, line_number: this.line_number, char_position: this.char_position };
            case 'K': return { ttype: TokenType.King, line_number: this.line_number, char_position: this.char_position };
            case 'Q': return { ttype: TokenType.Queen, line_number: this.line_number, char_position: this.char_position };
            case 'J': return { ttype: TokenType.Jack, line_number: this.line_number, char_position: this.char_position };
            case 'T': return { ttype: TokenType.Ten, line_number: this.line_number, char_position: this.char_position };
            case '9': return { ttype: TokenType.Nine, line_number: this.line_number, char_position: this.char_position };
            case '8': return { ttype: TokenType.Eight, line_number: this.line_number, char_position: this.char_position };
            case '7': return { ttype: TokenType.Seven, line_number: this.line_number, char_position: this.char_position };
            case '6': return { ttype: TokenType.Six, line_number: this.line_number, char_position: this.char_position };
            case '5': return { ttype: TokenType.Five, line_number: this.line_number, char_position: this.char_position };
            case '4': return { ttype: TokenType.Four, line_number: this.line_number, char_position: this.char_position };
            case '3': return { ttype: TokenType.Three, line_number: this.line_number, char_position: this.char_position };
            case '2': return { ttype: TokenType.Two, line_number: this.line_number, char_position: this.char_position };
            case 'o': return { ttype: TokenType.Offsuit, line_number: this.line_number, char_position: this.char_position };
            case 's': return { ttype: TokenType.Suited, line_number: this.line_number, char_position: this.char_position };
            case ',': return { ttype: TokenType.DelComma, line_number: this.line_number, char_position: this.char_position };
            case '+': return { ttype: TokenType.OpExtend, line_number: this.line_number, char_position: this.char_position };
            case '-': return { ttype: TokenType.OpRange, line_number: this.line_number, char_position: this.char_position };
            case '\0': return { ttype: TokenType.MetaEnd, line_number: this.line_number, char_position: this.char_position };
            default: return { ttype: TokenType.MetaIllegal, line_number: this.line_number, char_position: this.char_position };
        }
    }

    private skip_whitespace() {
        while (this.is_whitespace(this.peek_char())) {
            let ch = this.read_char();
            if (ch == '\n' || ch == '\r') {
                this.line_number++;
                this.char_position = 0;
            }
        }
    }

    private read_char(): string {
        if (this.input_pos >= this.input.length) {
            return '\0';
        }
        let ch = this.input[this.input_pos];
        this.input_pos++;
        this.char_position++;
        return ch;
    }

    private peek_char(): string {
        return this.input_pos < this.input.length ? this.input[this.input_pos] : '\0';
    }

    private is_whitespace(ch: string): boolean {
        return ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r';
    }
}
