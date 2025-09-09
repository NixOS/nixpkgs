{
  callPackage,
  runCommand,
  nix,
}:
let
  mkTest =
    package-path: expected-hash:
    let
      package = callPackage package-path { };
    in
    runCommand "testing ${package.pname}"
      {
        nativeBuildInputs = [ package ];
      }
      ''
        mkdir $out # satisfy mkDerivation contract
        actual=$(${nix}/bin/nix-hash --type sha256 --sri ${package})
        expected=${expected-hash}

        if [ "$actual" != "$expected" ] ; then
          echo "Failed test: actual: "$actual" != expected: "$expected""
          find ${package} -maxdepth 2 | head -100
          exit 1
        fi
      '';
in
{
  dmg = mkTest ./dmg-based-package.nix "sha256-Jfukle/bUwy0X/okdL8x1HxmmF7+AVjNjuwyEbqkY90=";
  pkg = mkTest ./pkg-based-package.nix "sha256-ZD1Zycaj69daNaC87cz9NEk9HBT5fhHtjHRmu2HeE10=";
  zip = mkTest ./zip-based-package.nix "sha256-wzYAppeBgRiXVktOHYc/QX0FIwo9WgtNXlmG444AHgE=";
  tar-xz = mkTest ./tar.xz-based-package.nix "sha256-uO38VmlD9rKjGazOSfFTiw3jLBZUHyNq5j+ohKvaQgM=";

}
