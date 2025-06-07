import { camelCase } from "@luca/cases";
import { say } from "cowsay";
import { pascalCase } from "cases";
import { parseArgs } from "@std/cli";

const flags = parseArgs(Deno.args, {
  string: ["text"],
});

if (!flags.text) {
  throw "--text required but not specified";
}

console.log(camelCase(say({ text: flags.text })));
console.log(pascalCase(say({ text: flags.text })));
