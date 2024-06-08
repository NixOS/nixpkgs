interface GHRelease {
  tag_name: string;
}

const decode = (buffer: Uint8Array) => new TextDecoder("utf-8").decode(buffer);
const decodeTrim = (b: Uint8Array) => decode(b).trimEnd();
export const run = async (command: string, args: string[]) => {
  const cmd = Deno.run({
    cmd: [command, ...args],
    stdout: "piped",
    stderr: "piped",
  });
  if (!(await cmd.status()).success) {
    const error = await cmd.stderrOutput().then(decodeTrim);
    // Known error we can ignore
    if (error.includes("'allow-unsafe-native-code-during-evaluation'")) {
      // Extract the target sha256 out of the error
      const target = "  got:    sha256:";
      const match = error
        .split("\n")
        .find((l) => l.includes(target))
        ?.split(target)[1];
      if (typeof match !== "undefined") {
        return match;
      }
    }
    throw new Error(error);
  }
  return cmd.output().then(decodeTrim);
};

// Exports
export const versionRegExp = /\d+\.\d+\.\d+/;
export const sha256RegExp = /[a-z0-9]{52}|sha256-.{44}/;

export const getExistingVersion = async (filePath: string) =>
  read(filePath).then(
    (s) => s.match(genValueRegExp("version", versionRegExp))?.shift() || "",
  );

export const getLatestVersion = (owner: string, repo: string) =>
  fetch(`https://api.github.com/repos/${owner}/${repo}/releases`)
    .then((res) => res.json())
    .then((res: GHRelease[]) => res[0].tag_name);

// The (?<=) and (?=) allow replace to only change inside
// Match the regex passed in or empty
export const genValueRegExp = (key: string, regex: RegExp) =>
  new RegExp(`(?<=${key} = ")(${regex.source}|)(?=")`);

export const logger = (name: string) => (...a: any) =>
  console.log(`[${name}]`, ...a);

export const read = Deno.readTextFile;
export const write = Deno.writeTextFile;
