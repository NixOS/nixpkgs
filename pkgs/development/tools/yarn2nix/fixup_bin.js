#!/usr/bin/env node
"use strict";

/* Usage:
 * node fixup_bin.js <output_dir> [<bin_pkg_1>, <bin_pkg_2> ... ]
 */

const fs = require("fs");
const path = require("path");

const output = process.argv[2];
const packages_to_publish_bin = process.argv.slice(3);
const derivation_bin_path = output + "/bin";

function processPackage(name) {
  console.log("Processing ", name);
  const package_path = output + "/node_modules/" + name;
  const package_json_path = package_path + "/package.json";
  const package_json = JSON.parse(fs.readFileSync(package_json_path));

  if (!package_json.bin) {
    console.log("No binaries provided");
    return;
  }

  // There are two alternative syntaxes for `bin`
  // a) just a plain string, in which case the name of the package is the name of the binary.
  // b) an object, where key is the name of the eventual binary, and the value the path to that binary.
  if (typeof package_json.bin == "string") {
    let bin_name = package_json.bin;
    package_json.bin = { };
    package_json.bin[package_json.name] = bin_name;
  }

  for (let binName in package_json.bin) {
    const bin_path = package_json.bin[binName];
    const full_bin_path = path.normalize(package_path + "/" + bin_path);
    fs.symlinkSync(full_bin_path, derivation_bin_path + "/"+ binName);
    console.log("Linked", binName);
  }
}

packages_to_publish_bin.forEach((pkg) => {
  processPackage(pkg);
});
