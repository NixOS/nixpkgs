{ lib, stdenv, symlinkJoin, fetchzip, ... }:

let
  version = "3.1.6.2"; # https://github.com/just-containers/s6-overlay/releases
  archParts = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.head archParts; # we only need e.g. `x86_64`

  # Installation docs: https://github.com/just-containers/s6-overlay?tab=readme-ov-file#installation
  overlayNoarch = fetchzip {
    url = "https://github.com/just-containers/s6-overlay/releases/download/v${version}/s6-overlay-noarch.tar.xz";
    hash = "sha256-la2Q2wKkJ2v2oHhr+phfMfYvYbuwjLN2FLZHwc3R1Ao=";
    stripRoot = false;
  };
  overlayForArch = fetchzip {
    url = "https://github.com/just-containers/s6-overlay/releases/download/v${version}/s6-overlay-${arch}.tar.xz";
    hash = "sha256-WT8MaqECqlurFGzL1EHk+eJ7DNidf2E5A577fH2cYAk=";
    stripRoot = false;
  };
  merged = symlinkJoin {
    name = "s6-overlay-merged";
    paths = [ overlayNoarch overlayForArch ];
  };

in
stdenv.mkDerivation {
  inherit version;
  pname = "s6-overlay";

  src = merged;
  dontUnpack = true;

  installPhase = ''
    cp -r ${merged} $out
  '';

  meta = with lib; {
    description = "s6-overlay -  s6 overlay for containers (includes execline, s6-linux-utils & a custom init)";
    homepage = "https://github.com/just-containers/s6-overlay";
    license = licenses.isc;
    maintainers = with maintainers; [ tennox ];
    platforms = platforms.linux;
  };
}
