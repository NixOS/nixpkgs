import * as toml from "https://deno.land/std@0.148.0/encoding/toml.ts";
import {
  getExistingVersion,
  logger,
  run,
  write,
} from "./common.ts";


const log = logger("librusty_v8");

export interface Architecture {
  nix: string;
  rust: string;
}
interface PrefetchResult {
  arch: Architecture;
  sha256: string;
}

const getLibrustyV8Version = async (
  owner: string,
  repo: string,
  version: string,
) =>
  fetch(`https://github.com/${owner}/${repo}/raw/${version}/Cargo.toml`)
    .then((res) => res.text())
    .then((txt) => toml.parse(txt).workspace.dependencies.v8.version);

const fetchArchShaTasks = (version: string, arches: Architecture[]) =>
  arches.map(
    async (arch: Architecture): Promise<PrefetchResult> => {
      log("Fetching:", arch.nix);
      const sha256 = await run("nix-prefetch", [
        `
{ fetchurl }:
fetchurl {
  url = "https://github.com/denoland/rusty_v8/releases/download/v${version}/librusty_v8_release_${arch.rust}.a";
}
`,
      ]);
      log("Done:    ", arch.nix);
      return { arch, sha256 };
    },
  );

const templateDeps = (version: string, deps: PrefetchResult[]) =>
  `# auto-generated file -- DO NOT EDIT!
{ rust, stdenv, fetchurl }:

let
  arch = rust.toRustTarget stdenv.hostPlatform;
  fetch_librusty_v8 = args: fetchurl {
    name = "librusty_v8-\${args.version}";
    url = "https://github.com/denoland/rusty_v8/releases/download/v\${args.version}/librusty_v8_release_\${arch}.a";
    sha256 = args.shas.\${stdenv.hostPlatform.system};
    meta = { inherit (args) version; };
  };
in
fetch_librusty_v8 {
  version = "${version}";
  shas = {
${deps.map(({ arch, sha256 }) => `    ${arch.nix} = "${sha256}";`).join("\n")}
  };
}
`;

export async function updateLibrustyV8(
  filePath: string,
  owner: string,
  repo: string,
  denoVersion: string,
  arches: Architecture[],
) {
  log("Starting librusty_v8 update");
  // 0.0.0
  const version = await getLibrustyV8Version(owner, repo, denoVersion);
  if (typeof version !== "string") {
    throw "no librusty_v8 version";
  }
  log("librusty_v8 version:", version);
  const existingVersion = await getExistingVersion(filePath);
  if (version === existingVersion) {
    log("Version already matches latest, skipping...");
    return;
  }
  const archShaResults = await Promise.all(fetchArchShaTasks(version, arches));
  await write(filePath, templateDeps(version, archShaResults));
  log("Finished deps update");
}
