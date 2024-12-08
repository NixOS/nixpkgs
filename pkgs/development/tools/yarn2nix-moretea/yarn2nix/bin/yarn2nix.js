#!/usr/bin/env node

const fs = require("fs");
const lockfile = require("@yarnpkg/lockfile");
const { docopt } = require("docopt");
const deepEqual = require("deep-equal");
const R = require("ramda");

const fixPkgAddMissingSha1 = require("../lib/fixPkgAddMissingSha1");
const mapObjIndexedReturnArray = require("../lib/mapObjIndexedReturnArray");
const generateNix = require("../lib/generateNix");

const USAGE = `
Usage: yarn2nix [options]

Options:
  -h --help           Shows this help.
  --no-nix            Hide the nix output
  --no-patch          Don't patch the lockfile if hashes are missing
  --lockfile=FILE     Specify path to the lockfile [default: ./yarn.lock].
  --builtin-fetchgit  Use builtin fetchGit for git dependencies to support on-the-fly generation of yarn.nix without an internet connection
`;

const options = docopt(USAGE);

const data = fs.readFileSync(options["--lockfile"], "utf8");

// json example:

// {
//   type:'success',
//   object:{
//     'abbrev@1':{
//       version:'1.0.9',
//       resolved:'https://registry.yarnpkg.com/abbrev/-/abbrev-1.0.9.tgz#91b4792588a7738c25f35dd6f63752a2f8776135'
//     },
//     'shell-quote@git+https://github.com/srghma/node-shell-quote.git#without_unlicenced_jsonify':{
//       version:'1.6.0',
//       resolved:'git+https://github.com/srghma/node-shell-quote.git#0aa381896e0cd7409ead15fd444f225807a61e0a'
//     },
//     '@graphile/plugin-supporter@git+https://1234user:1234pass@git.graphile.com/git/users/1234user/postgraphile-supporter.git':{
//       version:'1.6.0',
//       resolved:'git+https://1234user:1234pass@git.graphile.com/git/users/1234user/postgraphile-supporter.git#1234commit'
//     },
//   }
// }

const json = lockfile.parse(data);

if (json.type !== "success") {
  throw new Error("yarn.lock parse error");
}

// Check for missing hashes in the yarn.lock and patch if necessary

let pkgs = R.pipe(
  mapObjIndexedReturnArray((value, key) => ({
    ...value,
    nameWithVersion: key
  })),
  R.uniqBy(R.prop("resolved"))
)(json.object);

(async () => {
  if (!options["--no-patch"]) {
    pkgs = await Promise.all(R.map(fixPkgAddMissingSha1, pkgs));
  }

  const origJson = lockfile.parse(data);

  if (!deepEqual(origJson, json)) {
    console.error("found changes in the lockfile", options["--lockfile"]);

    if (options["--no-patch"]) {
      console.error("...aborting");
      process.exit(1);
    }

    fs.writeFileSync(options["--lockfile"], lockfile.stringify(json.object));
  }

  if (!options["--no-nix"]) {
    // print to stdout
    console.log(generateNix(pkgs, options["--builtin-fetchgit"]));
  }
})().catch(error => {
  console.error(error);

  process.exit(1);
});
