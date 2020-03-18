export enum TokenType {
    Ace,
    King,
    Queen,
    Jack,
    Ten,
    Nine,
    Eight,
    Seven,
    Six,
    Five,
    Four,
    Three,
    Two,
    Clubs,
    Diamonds,
    Hearts,
    SuitedOrSpades,
    Offsuit,
    DelComma,
    OpExtend,
    OpRange,
    MetaIllegal,
    MetaEnd
}

export type Token = {
    ttype: TokenType;
    line_number: number;
    char_position: number;
}

export function token_type_literal(ttype: TokenType): string {
    switch (ttype) {
        case TokenType.Ace: return 'A';
        case TokenType.King: return 'K';
        case TokenType.Queen: return 'Q';
        case TokenType.Jack: return 'J';
        case TokenType.Ten: return 'T';
        case TokenType.Nine: return '9';
        case TokenType.Eight: return '8';
        case TokenType.Seven: return '7';
        case TokenType.Six: return '6';
        case TokenType.Five: return '5';
        case TokenType.Four: return '4';
        case TokenType.Three: return '3';
        case TokenType.Two: return '2';
        case TokenType.Clubs: return 'c';
        case TokenType.Diamonds: return 'd';
        case TokenType.Hearts: return 'h';
        case TokenType.SuitedOrSpades: return 's';
        case TokenType.Offsuit: return 'o';
        default: return '';
    }
}
