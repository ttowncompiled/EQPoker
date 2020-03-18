import { TokenType } from "./token"

export type NodeType = Card | Join | RangeBetween | Extension;

export type Card = {
    rank: TokenType;
    suit: TokenType | null;
}

export type Join = {
    left: Card;
    right: Card;
}

export type RangeBetween = {
    start: Join;
    end: Join;
}

export type Extension = {
    left: Join;
}
