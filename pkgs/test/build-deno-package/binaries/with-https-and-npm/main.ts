import { camelCase } from "@luca/cases";
import { say } from "cowsay";
import { say as say_esm } from "cowsay-esm";
import { pascalCase } from "cases";
import { parseArgs } from "@std/cli";
import camelCase2 from "camelcase";
// @ts-types="npm:@types/absolute@0.0.32"
import absolute from "absolute";
// @deno-types="https://esm.sh/@types/abs@1.3.4/index.d.ts"
import abs from "abs";
import BufferStream from "bufferstream"
import { } from "./types.d.ts"
// this type comes from `deno.json`.compilerOptions.types
import type Buffers from "buffers"

const stream = new BufferStream({encoding:'utf8', size:'none'})
type my = Buffers;

const flags = parseArgs(Deno.args, {
  string: ["text"],
});

if (!flags.text) {
  throw "--text required but not specified";
}

console.log(absolute("/text"))
console.log(abs("./text"))
console.log(camelCase(say({ text: flags.text })));
console.log(camelCase2(say({ text: flags.text })));
console.log(pascalCase(say({ text: flags.text })));

console.log(camelCase(say_esm({ text: flags.text })));
console.log(camelCase2(say_esm({ text: flags.text })));
console.log(pascalCase(say_esm({ text: flags.text })));
