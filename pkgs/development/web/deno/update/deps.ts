import {
  getExistingVersion,
  genValueRegExp,
  logger,
  nixPrefetchURL,
  versionRegExp,
  write,
} from "./common.ts";

const log = logger("deps");

export interface Architecture {
  nix: string;
  rust: string;
}
interface PrefetchResult {
  arch: Architecture;
  sha256: string;
}

const getRustyV8Version = async (
  owner: string,
  repo: string,
  version: string,
) =>
  fetch(
    `https://github.com/${owner}/${repo}/raw/${version}/core/Cargo.toml`,
  )
    .then((res) => res.text())
    .then((txt) =>
      txt.match(genValueRegExp("rusty_v8", versionRegExp))?.shift()
    );

const archShaTasks = (version: string, arches: Architecture[]) =>
  arches.map(async (arch: Architecture): Promise<PrefetchResult> => {
    log("Fetching:", arch.nix);
    const sha256 = await nixPrefetchURL(
      [`https://github.com/denoland/rusty_v8/releases/download/v${version}/librusty_v8_release_${arch.rust}.a`],
    );
    log("Done:    ", arch.nix);
    return { arch, sha256 };
  });

const templateDeps = (version: string, deps: PrefetchResult[]) =>
  `# auto-generated file -- DO NOT EDIT!
{}:
rec {
  rustyV8Lib = {
    version = "${version}";
    sha256s = {
${deps.map((d) => `      ${d.arch.nix} = "${d.sha256}";`).join("\n")}
    };
  };
}
`;

export async function updateDeps(
  filePath: string,
  owner: string,
  repo: string,
  denoVersion: string,
  arches: Architecture[],
) {
  log("Starting deps update");
  // 0.0.0
  const version = await getRustyV8Version(owner, repo, denoVersion);
  if (typeof version !== "string") {
    throw "no rusty_v8 version";
  }
  log("rusty_v8 version:", version);
  const existingVersion = await getExistingVersion(filePath);
  if (version === existingVersion) {
    log("Version already matches latest, skipping...");
    return;
  }
  const archShaResults = await Promise.all(archShaTasks(version, arches));
  await write(filePath, templateDeps(version, archShaResults));
  log("Finished deps update");
}
