import { Card, Extension, Join, NodeType, RangeBetween } from "./ast";
import { Parser } from "./parser";
import { TokenType, token_type_literal } from "./token";

export function eval_input_range(input: string): Set<string> {
    let parser = new Parser(input);
    let node_types = parser.parse();
    let hand_types = new Set<string>();
    for (let node_type of node_types) {
        let hands = eval_node_type(node_type);
        for (let hand of hands) {
            if (! hand_types.has(hand)) {
                hand_types.add(hand);
            }
        }
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
    let left_rank = token_type_literal(join.left.rank);
    let left_suit = '';
    if (join.left.suit != null) {
        left_suit = token_type_literal((<TokenType> join.left.suit));
    }
    let right_rank = token_type_literal(join.right.rank);
    let right_suit = '';
    if (join.right.suit != null) {
        right_suit = token_type_literal((<TokenType> join.right.suit));
    }
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

function eval_range_between(range_between: RangeBetween): Set<string> {
    return new Set<string>();
}

function eval_extension(extension: Extension): Set<string> {
    return new Set<string>();
}
