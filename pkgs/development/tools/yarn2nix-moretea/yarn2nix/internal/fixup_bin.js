#!/usr/bin/env node

/* Usage:
 * node fixup_bin.js <bin_dir> <modules_dir> [<bin_pkg_1>, <bin_pkg_2> ... ]
 */

const fs = require("fs");
const path = require("path");

const derivationBinPath = process.argv[2];
const nodeModules = process.argv[3];
const packagesToPublishBin = process.argv.slice(4);

function processPackage(name) {
  console.log("fixup_bin: Processing ", name);

  const packagePath = `${nodeModules}/${name}`;
  const packageJsonPath = `${packagePath}/package.json`;
  const packageJson = JSON.parse(fs.readFileSync(packageJsonPath));

  if (!packageJson.bin) {
    console.log("fixup_bin: No binaries provided");
    return;
  }

  // There are two alternative syntaxes for `bin`
  // a) just a plain string, in which case the name of the package is the name of the binary.
  // b) an object, where key is the name of the eventual binary, and the value the path to that binary.
  if (typeof packageJson.bin === "string") {
    const binName = packageJson.bin;
    packageJson.bin = {};
    packageJson.bin[packageJson.name] = binName;
  }

  // eslint-disable-next-line no-restricted-syntax, guard-for-in
  for (const binName in packageJson.bin) {
    const binPath = packageJson.bin[binName];
    const normalizedBinName = binName.replace("@", "").replace("/", "-");

    const targetPath = path.normalize(`${packagePath}/${binPath}`);
    const createdPath = `${derivationBinPath}/${normalizedBinName}`;

    console.log(
      `fixup_bin: creating link ${createdPath} that points to ${targetPath}`
    );

    fs.symlinkSync(targetPath, createdPath);
  }
}

packagesToPublishBin.forEach(pkg => {
  processPackage(pkg);
});
