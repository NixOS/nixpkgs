import { camelCase } from "@luca/cases";
import { pascalCase } from "cases";
import { parseArgs } from "@std/cli";
import { say } from "cowsay";
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
