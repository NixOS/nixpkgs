import { camelCase } from "@luca/cases";
import { say } from "cowsay";
import { say as say_esm } from "cowsay-esm";
import { pascalCase } from "cases";
import { parseArgs } from "@std/cli";
import camelCase2 from "camelcase";

const flags = parseArgs(Deno.args, {
  string: ["text"],
});

if (!flags.text) {
  throw "--text required but not specified";
}


console.log(camelCase(say({ text: flags.text })));
console.log(camelCase2(say({ text: flags.text })));
console.log(pascalCase(say({ text: flags.text })));

console.log(camelCase(say_esm({ text: flags.text })));
console.log(camelCase2(say_esm({ text: flags.text })));
console.log(pascalCase(say_esm({ text: flags.text })));
