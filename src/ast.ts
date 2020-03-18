import { TokenType } from "./token"

export type NodeType = Card | Join | RangeBetween | Extension;

export interface Card {
    rank: TokenType;
    suit: TokenType | null;
}

export interface Join {
    left: Card;
    right: Card;
}

export interface RangeBetween {
    start: Join;
    end: Join;
}

export interface Extension {
    left: Join;
}
