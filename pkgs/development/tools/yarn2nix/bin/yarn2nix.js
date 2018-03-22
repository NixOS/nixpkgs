#!/usr/bin/env node
"use strict";

const crypto = require('crypto');
const fs = require("fs");
const https = require("https");
const path = require("path");
const util = require("util");

const lockfile = require("@yarnpkg/lockfile")
const docopt = require("docopt").docopt;

////////////////////////////////////////////////////////////////////////////////

const USAGE = `
Usage: yarn2nix [options]

Options:
  -h --help        Shows this help.
  --no-nix         Hide the nix output
  --no-patch       Don't patch the lockfile if hashes are missing
  --lockfile=FILE  Specify path to the lockfile [default: ./yarn.lock].
`

const HEAD = `
{fetchurl, linkFarm}: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
`.trim();

////////////////////////////////////////////////////////////////////////////////

function generateNix(lockedDependencies) {
  let found = {};

  console.log(HEAD)

  for (var depRange in lockedDependencies) {
    let dep = lockedDependencies[depRange];

    let depRangeParts = depRange.split('@');
    let [url, sha1] = dep["resolved"].split("#");
    let file_name = path.basename(url)

    if (found.hasOwnProperty(file_name)) {
      continue;
    } else {
      found[file_name] = null;
    }


    console.log(`
    {
      name = "${file_name}";
      path = fetchurl {
        name = "${file_name}";
        url  = "${url}";
        sha1 = "${sha1}";
      };
    }`)
  }

  console.log("  ];")
  console.log("}")
}


function getSha1(url) {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      const { statusCode } = res;
      const hash = crypto.createHash('sha1');
      if (statusCode !== 200) {
        const err = new Error('Request Failed.\n' +
                          `Status Code: ${statusCode}`);
        // consume response data to free up memory
        res.resume();
        reject(err);
      }

      res.on('data', (chunk) => { hash.update(chunk); });
      res.on('end', () => { resolve(hash.digest('hex')) });
      res.on('error', reject);
    });
  });
};

function updateResolvedSha1(pkg) {
  // local dependency
  if (!pkg.resolved) { return Promise.resolve(); }
  let [url, sha1] = pkg.resolved.split("#", 2)
  if (!sha1) {
    return new Promise((resolve, reject) => {
      getSha1(url).then(sha1 => {
        pkg.resolved = `${url}#${sha1}`;
        resolve();
      }).catch(reject);
    });
  } else {
    // nothing to do
    return Promise.resolve();
  };
}

function values(obj) {
  var entries = [];
  for (let key in obj) {
    entries.push(obj[key]);
  }
  return entries;
}

////////////////////////////////////////////////////////////////////////////////
// Main
////////////////////////////////////////////////////////////////////////////////

var options = docopt(USAGE);

let data = fs.readFileSync(options['--lockfile'], 'utf8')
let json = lockfile.parse(data)
if (json.type != "success") {
  throw new Error("yarn.lock parse error")
}

// Check fore missing hashes in the yarn.lock and patch if necessary
var pkgs = values(json.object);
Promise.all(pkgs.map(updateResolvedSha1)).then(() => {
  let newData = lockfile.stringify(json.object);

  if (newData != data) {
    console.error("found changes in the lockfile", options["--lockfile"]);

    if (options["--no-patch"]) {
      console.error("...aborting");
      process.exit(1);
    }

    fs.writeFileSync(options['--lockfile'], newData);
  }

  if (!options['--no-nix']) {
    generateNix(json.object);
  }
})
