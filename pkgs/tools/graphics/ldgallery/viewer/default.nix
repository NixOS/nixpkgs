{ lib, stdenv, fetchFromGitHub, pkgs, pandoc, CoreServices }:

let
  # Note for maintainers:
  # * keep version in sync with the ldgallery compiler
  # * regenerate node-*.nix with `./generate.sh <git release tag>`
  sourcePkg = fetchFromGitHub {
    owner = "pacien";
    repo = "ldgallery";
    rev = "v2.1";
    sha256 = "sha256-i+Boo+Mpx/EL+LBajtOQJfpi4EF5AVtRnGtyXKD2n6A=";
  };

  nodePackages = import ./node-composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };

  nodePkg = nodePackages.package.override {
    src = "${sourcePkg}/viewer";
    postInstall = "npm run build";
    buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];
  };

in

# making sure that the source and the node package are in sync
assert lib.versions.majorMinor nodePkg.version == lib.removePrefix "v" sourcePkg.rev;

stdenv.mkDerivation {
  pname = nodePkg.packageName;
  version = nodePkg.version;
  src = nodePkg;

  buildInputs = [ pandoc ];

  installPhase = ''
    mkdir -p "$out/share/ldgallery"
    cp -rp "lib/node_modules/ldgallery-viewer/dist" \
      "$out/share/ldgallery/viewer/"
    cp -rp "${sourcePkg}/example" \
      "$out/share/ldgallery/viewer/"

    mkdir -p "$out/share/man/man7"
    pandoc --standalone --to man \
      "lib/node_modules/ldgallery-viewer/ldgallery-viewer.7.md" \
      --output "$out/share/man/man7/ldgallery-viewer.7"
  '';
}
