# Execute with $ nix-build --attr darwin.installBinaryPackageTests
{
  callPackage,
  runCommand,
  nix,
  lib,
}:
let
  mkTest =
    package-path: expected-hash:
    let
      package = callPackage package-path { };
    in
    runCommand "testing ${package.pname}" { } ''
      mkdir $out # satisfy mkDerivation contract
      actualHash=$(${lib.getExe' nix "nix-hash"} --type sha256 --sri ${package})

      if [ "$actualHash" != "${expected-hash}" ]; then
        echo error: hash mismatch in darwin.installBinaryApplication test for package ${package-path}:
        echo "specified: ${expected-hash}"
        echo "   got:    $actualHash"

        find ${package} -maxdepth 2 | head -100
        exit 1
      fi
    '';
in
{
  dmg = mkTest ./dmg-based-package.nix "sha256-Jfukle/bUwy0X/okdL8x1HxmmF7+AVjNjuwyEbqkY90=";
  pkg = mkTest ./pkg-based-package.nix "sha256-ZD1Zycaj69daNaC87cz9NEk9HBT5fhHtjHRmu2HeE10=";
  tar-xz = mkTest ./tar.xz-based-package.nix "sha256-uO38VmlD9rKjGazOSfFTiw3jLBZUHyNq5j+ohKvaQgM=";
  zip = mkTest ./zip-based-package.nix "sha256-wzYAppeBgRiXVktOHYc/QX0FIwo9WgtNXlmG444AHgE=";
}
