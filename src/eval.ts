import { Card, Extension, Join, NodeType, RangeBetween } from "./ast";
import { Parser } from "./parser";
import { TokenType, token_type_literal } from "./token";

export function eval_input_range(input: string): Set<string> {
    let parser = new Parser(input);
    let node_types = parser.parse();
    let hand_types = new Set<string>();
    for (let node_type of node_types) {
        merge_hands(hand_types, eval_node_type(node_type));
    }
    return hand_types;
}

function eval_node_type(node_type: NodeType): Set<string> {
    if ('left' in node_type && 'right' in node_type) {
        return eval_join((<Join> node_type));
    }
    if ('start' in node_type && 'end' in node_type) {
        return eval_range_between((<RangeBetween> node_type));
    }
    if ('left' in node_type) {
        return eval_extension((<Extension> node_type));
    }
    return new Set<string>();
}

function eval_join(join: Join): Set<string> {
    let [left_rank, left_suit] = eval_card(join.left);
    let [right_rank, right_suit] = eval_card(join.right);
    if (left_suit == '' && right_suit == 's') {
        return eval_suited(left_rank, right_rank);
    } else if (left_suit == '' && right_suit == 'o') {
        return eval_offsuit(left_rank, right_rank);
    } else if (left_rank == right_rank && left_suit == '' && right_suit == '') {
        return eval_pocket_pair(left_rank);
    } else if ((left_suit == 'c' || left_suit == 'd' || left_suit == 'h' || left_suit == 's') && (right_suit == 'c' || right_suit == 'd' || right_suit == 'h' || right_suit == 's')) {
        let hand_types = new Set<string>();
        hand_types.add(`${left_rank}${left_suit}${right_rank}${right_suit}`);
        return hand_types;
    } else if (left_suit == '' && right_suit == '') {
        return eval_suited_and_offsuit(left_rank, right_rank);
    } else {
        return new Set<string>();
    }
}

function eval_range_between(range_between: RangeBetween): Set<string> {
    return new Set<string>();
}

function eval_extension(extension: Extension): Set<string> {
    let join = extension.left;
    let hand_types = eval_join(join);
    if (join.left.rank == join.right.rank && join.left.suit == null && join.right.suit == null) {
        let rank = increment_rank(join.right.rank);
        while (rank != null) {
            join.left.rank = rank;
            join.right.rank = rank;
            hand_types = merge_hands(hand_types, eval_join(join));
            rank = increment_rank(join.right.rank);
        }
        return hand_types;
    } else {
        let right_rank = increment_rank(join.right.rank);
        while (! (right_rank == null || right_rank == join.left.rank)) {
            join.right.rank = right_rank;
            hand_types = merge_hands(hand_types, eval_join(join));
            right_rank = increment_rank(join.right.rank);
        }
        return hand_types;
    }
}

function eval_suited(left_rank: string, right_rank: string): Set<string> {
    let hand_types = new Set<string>();
    hand_types.add(`${left_rank}c${right_rank}c`);
    hand_types.add(`${left_rank}d${right_rank}d`);
    hand_types.add(`${left_rank}h${right_rank}h`);
    hand_types.add(`${left_rank}s${right_rank}s`);
    return hand_types;
}

function eval_offsuit(left_rank: string, right_rank: string): Set<string> {
    let hand_types = new Set<string>();
    hand_types.add(`${left_rank}c${right_rank}d`);
    hand_types.add(`${left_rank}c${right_rank}h`);
    hand_types.add(`${left_rank}c${right_rank}s`);
    hand_types.add(`${left_rank}d${right_rank}c`);
    hand_types.add(`${left_rank}d${right_rank}h`);
    hand_types.add(`${left_rank}d${right_rank}s`);
    hand_types.add(`${left_rank}h${right_rank}c`);
    hand_types.add(`${left_rank}h${right_rank}d`);
    hand_types.add(`${left_rank}h${right_rank}s`);
    hand_types.add(`${left_rank}s${right_rank}c`);
    hand_types.add(`${left_rank}s${right_rank}d`);
    hand_types.add(`${left_rank}s${right_rank}h`);
    return hand_types;
}

function eval_suited_and_offsuit(left_rank: string, right_rank: string): Set<string> {
    let hand_types = new Set<string>();
    hand_types.add(`${left_rank}c${right_rank}c`);
    hand_types.add(`${left_rank}c${right_rank}d`);
    hand_types.add(`${left_rank}c${right_rank}h`);
    hand_types.add(`${left_rank}c${right_rank}s`);
    hand_types.add(`${left_rank}d${right_rank}c`);
    hand_types.add(`${left_rank}d${right_rank}d`);
    hand_types.add(`${left_rank}d${right_rank}h`);
    hand_types.add(`${left_rank}d${right_rank}s`);
    hand_types.add(`${left_rank}h${right_rank}c`);
    hand_types.add(`${left_rank}h${right_rank}d`);
    hand_types.add(`${left_rank}h${right_rank}h`);
    hand_types.add(`${left_rank}h${right_rank}s`);
    hand_types.add(`${left_rank}s${right_rank}c`);
    hand_types.add(`${left_rank}s${right_rank}d`);
    hand_types.add(`${left_rank}s${right_rank}h`);
    hand_types.add(`${left_rank}s${right_rank}s`);
    return hand_types;
}

function eval_pocket_pair(rank: string): Set<string> {
    let hand_types = new Set<string>();
    hand_types.add(`${rank}c${rank}d`);
    hand_types.add(`${rank}c${rank}h`);
    hand_types.add(`${rank}c${rank}s`);
    hand_types.add(`${rank}d${rank}h`);
    hand_types.add(`${rank}d${rank}s`);
    hand_types.add(`${rank}h${rank}s`);
    return hand_types;
}

function eval_card(card: Card): [string, string] {
    let left_rank = token_type_literal(card.rank);
    let left_suit = '';
    if (card.suit != null) {
        left_suit = token_type_literal((<TokenType> card.suit));
    }
    return [left_rank, left_suit];
}

function increment_rank(ttype: TokenType): TokenType | null {
    switch (ttype) {
        case TokenType.King: return TokenType.Ace;
        case TokenType.Queen: return TokenType.King;
        case TokenType.Jack: return TokenType.Queen;
        case TokenType.Ten: return TokenType.Jack;
        case TokenType.Nine: return TokenType.Ten;
        case TokenType.Eight: return TokenType.Nine;
        case TokenType.Seven: return TokenType.Eight;
        case TokenType.Six: return TokenType.Seven;
        case TokenType.Five: return TokenType.Six;
        case TokenType.Four: return TokenType.Five;
        case TokenType.Three: return TokenType.Four;
        case TokenType.Two: return TokenType.Three;
        default: return null;
    }
}

function merge_hands(A: Set<string>, B: Set<string>): Set<string> {
    for (let b of B) {
        if (! A.has(b)) {
            A.add(b);
        }
    }
    return A;
}
