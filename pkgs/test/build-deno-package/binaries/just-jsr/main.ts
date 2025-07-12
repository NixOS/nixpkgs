import { camelCase } from "@luca/cases";
import { parseArgs } from "@std/cli";


const flags = parseArgs(Deno.args, {
  string: ["text"],
});

if (!flags.text) {
  throw "--text required but not specified";
}

console.log(camelCase({ text: flags.text }));
