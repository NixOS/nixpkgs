#!/usr/bin/env nix-shell
/*
#!nix-shell -i "deno run --allow-net --allow-run --allow-read --allow-write" -p deno git nix-prefetch
*/
import { findUp } from "https://deno.land/x/easy_std@v0.4.6/src/path.ts";
import { resolve, dirname, fromFileUrl } from "https://deno.land/std@0.224.0/path/mod.ts";
import { getExistingVersion, getLatestVersion, logger } from "./common.ts";
import { Architecture, updateLibrustyV8 } from "./librusty_v8.ts";
import { updateSrc } from "./src.ts";


const __dirname = dirname(fromFileUrl(import.meta.url))
const log = logger("update");
const nixpkgs = resolve(await findUp('.git', __dirname), '..');
// TODO: Read values from default.nix
const owner = "denoland";
const repo = "deno";
const denoDir = resolve(__dirname, '..');
const src = `${denoDir}/default.nix`;
const librusty_v8 = `${denoDir}/librusty_v8.nix`;
const architectures: Architecture[] = [
  { nix: "x86_64-linux", rust: "x86_64-unknown-linux-gnu" },
  { nix: "aarch64-linux", rust: "aarch64-unknown-linux-gnu" },
  { nix: "x86_64-darwin", rust: "x86_64-apple-darwin" },
  { nix: "aarch64-darwin", rust: "aarch64-apple-darwin" },
];

log("Updating deno");

log("Getting latest deno version");
const version = await getLatestVersion(owner, repo);
const existingVersion = await getExistingVersion(src);
const trimVersion = version.substr(1); // Strip v from v0.0.0
log("Latest version:   ", trimVersion);
log("Extracted version:", existingVersion);
if (trimVersion === existingVersion) {
  log("Version already matches latest, skipping...");
  Deno.exit(0);
}

const tasks = [
  updateSrc(src, nixpkgs, version),
  updateLibrustyV8(librusty_v8, owner, repo, version, architectures),
];
await Promise.all(tasks);
log("Updating deno complete");
