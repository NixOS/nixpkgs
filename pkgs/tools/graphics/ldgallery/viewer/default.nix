{ lib, stdenv, fetchFromGitHub, pkgs, nodejs-14_x, pandoc, CoreServices }:

with lib;

let
  # Note for maintainers:
  # * keep version in sync with the ldgallery compiler
  # * regenerate node-*.nix with `./generate.sh <git release tag>`
  sourcePkg = fetchFromGitHub {
    owner = "pacien";
    repo = "ldgallery";
    rev = "v2.0";
    sha256 = "1a82wy6ns1434gdba2l04crvr5waf03y02bappcxqci2cfb1cznz";
  };

  nodePackages = import ./node-composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;

    # some native node dependencies still require NodeJS 12 with Python 2
    nodejs = nodejs-14_x;
  };

  nodePkg = nodePackages.package.override {
    src = "${sourcePkg}/viewer";
    postInstall = "npm run build";
    buildInputs = optionals stdenv.isDarwin [ CoreServices ];
  };

in

# making sure that the source and the node package are in sync
assert versions.majorMinor nodePkg.version == removePrefix "v" sourcePkg.rev;

stdenv.mkDerivation {
  pname = nodePkg.packageName;
  version = nodePkg.version;
  src = nodePkg;

  buildInputs = [ pandoc ];

  installPhase = ''
    mkdir -p "$out/share/ldgallery"
    cp -rp "lib/node_modules/ldgallery-viewer/dist" \
      "$out/share/ldgallery/viewer/"
    cp -rp "lib/node_modules/ldgallery-viewer/examples" \
      "$out/share/ldgallery/viewer/"

    mkdir -p "$out/share/man/man7"
    pandoc --standalone --to man \
      "lib/node_modules/ldgallery-viewer/ldgallery-viewer.7.md" \
      --output "$out/share/man/man7/ldgallery-viewer.7"
  '';
}
