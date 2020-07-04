interface GHRelease {
  tag_name: string;
}

const decode = (buffer: Uint8Array) => new TextDecoder("utf-8").decode(buffer);
const run = async (command: string, args: string[]) => {
  const cmd = Deno.run(
    { cmd: [command, ...args], stdout: "piped", stderr: "piped" },
  );
  if (!(await cmd.status()).success) {
    throw await cmd.stderrOutput().then((b) => decode(b));
  }
  return cmd.output().then((b) => decode(b).trimEnd());
};

// Exports
export const versionRegExp = /\d+\.\d+\.\d+/;
export const sha256RegExp = /[a-z0-9]{52}/;

export async function commit(
  name: string,
  oldVer: string,
  newVer: string,
  files: string[],
) {
  await run("git", ["add", ...files]);
  await run("git", ["commit", "-m", `${name}: ${oldVer} -> ${newVer}`]);
}

export const getExistingVersion = async (filePath: string) =>
  read(filePath).then((s) =>
    s.match(genValueRegExp("version", versionRegExp))?.shift() || ""
  );

export const getLatestVersion = (owner: string, repo: string) =>
  fetch(`https://api.github.com/repos/${owner}/${repo}/releases`)
    .then((res) => res.json())
    .then((res: GHRelease[]) => res[0].tag_name);

// The (?<=) and (?=) allow replace to only change inside
// Match the regex passed in or empty
export const genValueRegExp = (key: string, regex: RegExp) =>
  new RegExp(`(?<=${key} = ")(${regex.source}|)(?=")`);

export const logger = (name: string) =>
  (...a: any) => console.log(`[${name}]`, ...a);

export const nixPrefetch = (args: string[]) => run("nix-prefetch", args);
export const nixPrefetchURL = (args: string[]) => run("nix-prefetch-url", args);

export const read = Deno.readTextFile;
export const write = Deno.writeTextFile;
