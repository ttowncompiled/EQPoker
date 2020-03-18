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
