import { Card, Join, NodeType } from "./ast";
import { Lexer } from "./lexer";
import { Token, TokenType } from "./token";

export enum Precedence {
    Lowest = 1,
    Extend,
    Range,
    Join,
    Prefix
}

export class Parser {
    private lexer: Lexer;
    private peek_token: Token;

    public constructor(input: string) {
        this.lexer = new Lexer(input);
        this.peek_token = this.lexer.next_token();
    }

    public parse(): NodeType | null {
        let curr_token = this.next_token();
        if (curr_token.ttype == TokenType.DelComma || curr_token.ttype == TokenType.MetaEnd) {
            return null;
        }
        return this.parse_expression_with_precedence(curr_token, Precedence.Lowest);
    }

    private parse_expression_with_precedence(curr_token: Token, precedence: Precedence): NodeType | null {
        let prefix = this.do_prefix_parse_fn(curr_token);
        if (prefix == null) {
            return null;
        }
        let left: NodeType = (<Card> prefix);
        while (! (this.peek_token.ttype == TokenType.DelComma || this.peek_token.ttype == TokenType.MetaEnd) && precedence < this.precedence(this.peek_token.ttype)) {
            if (this.has_infix_parse_fn(this.peek_token.ttype)) {
                let curr_token = this.next_token();
                left = this.parse_infix_expression((<NodeType> left), curr_token);
                if (left == null) {
                    return null;
                }
            } else if (this.has_postfix_parse_fn(this.peek_token.ttype)) {
                let curr_token = this.next_token();
                left = this.parse_postfix_expression((<NodeType> left), curr_token);
                if (left == null) {
                    return null;
                }
            } else {
                return (<NodeType> left);
            }
        }
        return (<NodeType> left);
    }

    private do_prefix_parse_fn(curr_token: Token): Card | null {
        switch (curr_token.ttype) {
            case TokenType.Ace: this.parse_prefix_expression(TokenType.Ace);
            case TokenType.King: this.parse_prefix_expression(TokenType.King);
            case TokenType.Queen: this.parse_prefix_expression(TokenType.Queen);
            case TokenType.Jack: this.parse_prefix_expression(TokenType.Jack);
            case TokenType.Ten: this.parse_prefix_expression(TokenType.Ten);
            case TokenType.Nine: this.parse_prefix_expression(TokenType.Nine);
            case TokenType.Eight: this.parse_prefix_expression(TokenType.Eight);
            case TokenType.Seven: this.parse_prefix_expression(TokenType.Seven);
            case TokenType.Six: this.parse_prefix_expression(TokenType.Six);
            case TokenType.Five: this.parse_prefix_expression(TokenType.Five);
            case TokenType.Four: this.parse_prefix_expression(TokenType.Four);
            case TokenType.Three: this.parse_prefix_expression(TokenType.Three);
            case TokenType.Two: this.parse_prefix_expression(TokenType.Two);
            default: return null;
        }
    }

    private parse_prefix_expression(ttype: TokenType): Card | null {
        switch (this.peek_token.ttype) {
            case TokenType.Clubs:
                this.next_token();
                return { rank: ttype, suit: TokenType.Clubs };
            case TokenType.Diamonds:
                this.next_token();
                return { rank: ttype, suit: TokenType.Diamonds };
            case TokenType.Hearts:
                this.next_token();
                return { rank: ttype, suit: TokenType.Hearts };
            case TokenType.SuitedOrSpades:
                this.next_token();
                return { rank: ttype, suit: TokenType.SuitedOrSpades };
            case TokenType.Offsuit:
                this.next_token();
                return { rank: ttype, suit: TokenType.Offsuit };
            default:
                return { rank: ttype, suit: null };
        }
    }

    private parse_infix_expression(left: NodeType, curr_token: Token): NodeType | null {
        let op = curr_token.ttype;
        if (op == TokenType.OpRange) {
            curr_token = this.next_token();
        }
        let right = this.parse_expression_with_precedence(curr_token, this.precedence(op));
        if (right == null) {
            return null;
        }
        if (op == TokenType.OpRange) {
            return { start: (<Join> left), end: (<Join> right) };
        }
        return { left: (<Card> left), right: (<Card> right) };
    }

    private parse_postfix_expression(left: NodeType, curr_token: Token): NodeType | null {
        switch (curr_token.ttype) {
            case TokenType.OpExtend: return { left: (<Join> left) };
            default: return null;
        }
    }

    private next_token(): Token {
        let curr_token = this.peek_token;
        this.peek_token = this.lexer.next_token();
        return curr_token;
    }

    private precedence(ttype: TokenType): Precedence {
        switch (ttype) {
            case TokenType.Ace: return Precedence.Join;
            case TokenType.King: return Precedence.Join;
            case TokenType.Queen: return Precedence.Join;
            case TokenType.Jack: return Precedence.Join;
            case TokenType.Ten: return Precedence.Join;
            case TokenType.Nine: return Precedence.Join;
            case TokenType.Eight: return Precedence.Join;
            case TokenType.Seven: return Precedence.Join;
            case TokenType.Six: return Precedence.Join;
            case TokenType.Five: return Precedence.Join;
            case TokenType.Four: return Precedence.Join;
            case TokenType.Three: return Precedence.Join;
            case TokenType.Two: return Precedence.Join;
            case TokenType.OpExtend: return Precedence.Extend;
            case TokenType.OpRange: return Precedence.Range;
            default: return Precedence.Lowest;
        }
    }

    private has_infix_parse_fn(ttype: TokenType): boolean {
        switch (ttype) {
            case TokenType.Ace: return true;
            case TokenType.King: return true;
            case TokenType.Queen: return true;
            case TokenType.Jack: return true;
            case TokenType.Ten: return true;
            case TokenType.Nine: return true;
            case TokenType.Eight: return true;
            case TokenType.Seven: return true;
            case TokenType.Six: return true;
            case TokenType.Five: return true;
            case TokenType.Four: return true;
            case TokenType.Three: return true;
            case TokenType.Two: return true;
            case TokenType.OpRange: return true;
            default: return false;
        }
    }

    private has_postfix_parse_fn(ttype: TokenType): boolean {
        switch (ttype) {
            case TokenType.OpExtend: return true;
            default: return false;
        }
    }
}
