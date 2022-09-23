import {
  genValueRegExp,
  logger,
  read,
  run,
  sha256RegExp,
  versionRegExp,
  write,
} from "./common.ts";

interface Replacer {
  regex: RegExp;
  value: string;
}

const log = logger("src");

const prefetchSha256 = (nixpkgs: string, version: string) =>
  run("nix-prefetch", ["-f", nixpkgs, "deno.src", "--rev", version]);
const prefetchCargoSha256 = (nixpkgs: string) =>
  run(
    "nix-prefetch",
    [`{ sha256 }: (import ${nixpkgs} {}).deno.cargoDeps.overrideAttrs (_: { inherit sha256; })`],
  );

const replace = (str: string, replacers: Replacer[]) =>
  replacers.reduce(
    (str, r) => str.replace(r.regex, r.value),
    str,
  );

const updateNix = (filePath: string, replacers: Replacer[]) =>
  read(filePath).then((str) => write(filePath, replace(str, replacers)));

const genVerReplacer = (k: string, value: string): Replacer => (
  { regex: genValueRegExp(k, versionRegExp), value }
);
const genShaReplacer = (k: string, value: string): Replacer => (
  { regex: genValueRegExp(k, sha256RegExp), value }
);

export async function updateSrc(
  filePath: string,
  nixpkgs: string,
  denoVersion: string,
) {
  log("Starting src update");
  const trimVersion = denoVersion.substr(1);
  log("Fetching sha256 for:", trimVersion);
  const sha256 = await prefetchSha256(nixpkgs, denoVersion);
  log("sha256 to update:", sha256);
  await updateNix(
    filePath,
    [
      genVerReplacer("version", trimVersion),
      genShaReplacer("sha256", sha256),
    ],
  );
  log("Fetching cargoSha256 for:", sha256);
  const cargoSha256 = await prefetchCargoSha256(nixpkgs);
  log("cargoSha256 to update:", cargoSha256);
  await updateNix(
    filePath,
    [genShaReplacer("cargoSha256", cargoSha256)],
  );
  log("Finished src update");
}
