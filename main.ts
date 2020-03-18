import { eval_input_range } from "./src/eval";

function main() {
    console.log(eval_input_range("AKs"));
    console.log(eval_input_range("AKo"));
    console.log(eval_input_range("AK"));
    console.log(eval_input_range("AA"));
    console.log(eval_input_range("AcKd"));
    console.log(eval_input_range("AKs,AKo"));
    console.log(eval_input_range("AQs+"));
    console.log(eval_input_range("AQo+"));
    console.log(eval_input_range("QQ+"));
    console.log(eval_input_range("AcQc+"));
    console.log(eval_input_range("AJs-AKs"));
    console.log(eval_input_range("AKs-AJs"));
    console.log(eval_input_range("AKo-AJo"));
    console.log(eval_input_range("AK-AJ"));
    console.log(eval_input_range("AA-JJ"));
}

main();
