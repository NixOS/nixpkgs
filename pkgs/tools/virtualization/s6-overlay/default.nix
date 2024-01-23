{ lib, stdenv, symlinkJoin,fetchzip, fetchFromGitHub, fetchurl, glibc, makeWrapper, musl, fetchgit, system, ... }:

let
  version = "3.1.6.2";
  archParts = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.head archParts; # we only need e.g. `x86_64`
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

  # Attempt 2: fetch individual deps (was complicated - and if we fetch deps outside nix, we might as well fetch the release tarball, right?)
  # arch = "${system}-musl";
  # skaToolchain = fetchurl {
  #   url = "https://skarnet.org/toolchains/cross/${arch}_pc-13.2.0.tar.xz";
  #   sha256 = "06nfa8gs9dmsjqhml5hq35ddc7zg4yg1ak1q4sjv5xjpwnp6id4s";
  # };
  # skaLibs = fetchgit {
  #   url = "git://git.skarnet.org/skalibs";
  #   rev = "v2.14.0.1";
  #   sha256 = "sha256-kfJXF41p2jyHt/1m5xNv1QRSvE8sxnSIYfCoFN4xrEk=";
  # };
  # skaExecline = fetchgit {
  #   url = "git://git.skarnet.org/execline";
  #   rev = "v2.9.4.0";
  #   sha256 = "sha256-eettzy++UsE834AfRstEFk61fDpbQxckZFZD00vU4xo=";
  # };
  # skaS6 = fetchgit {
  #   url = "git://git.skarnet.org/s6";
  #   rev = "v2.12.0.2";
  #   sha256 = "sha256-AjptMPiuI0vrGhDXW0Xa0AhVpzHVw2C5vMazBf3yGds=";
  # };
in
stdenv.mkDerivation {
  inherit version;
  pname = "s6-overlay";

  src = merged;
  # ? or this: 
  #srcs = [ overlayNoarch overlayForArch ];
  dontUnpack = true;
  
  # src = fetchFromGitHub {
  #   owner = "just-containers";
  #   repo = pname;
  #   rev = "v${version}";
  #   sha256 = "sha256-S0WSGuWLHtIr47vHeYkMd2SBo+ez6UlQCBT/cxIE7Xw=";
  # };

  # Attempt 1: at gettings deps from nix (was too finicky, lots of deps with specific versions)
  # buildInputs = [ makeWrapper ];
  # buildPhase = ''
  # mkdir -p $out/sources/${arch}_pc-13.2.0/bin
  # # Link the actual gcc binary
  # ln -sf ${gcc}/bin/gcc $out/sources/${arch}_pc-13.2.0/bin/${arch}-gcc
  # # Create a dummy .tar.xz file & set the modification time .tar.xz file to match the gcc binary (to not trigger make)
  # touch -r $out/sources/${arch}_pc-13.2.0/bin/${arch}-gcc $out/sources/${arch}_pc-13.2.0.tar.xz

  # Attempt 2
  # buildInputs = [ makeWrapper musl ];
  # buildPhase = ''
  # mkdir -p $out/sources $out/build-x86_64-linux-musl/
  # ln -s ${skaToolchain} $out/sources/${arch}_pc-13.2.0.tar.xz
  # ln -s ${skaLibs} $out/sources/skalibs
  # cp -r ${skaLibs} $out/build-x86_64-linux-musl/skalibs-v2.14.0.1 && rm -rf $out/build-x86_64-linux-musl/skalibs-v2.14.0.1/.git
  # chmod -R u+w $out/build-x86_64-linux-musl/skalibs-v2.14.0.1
  # ln -s ${skaExecline} $out/sources/execline
  # cp -r ${skaExecline} $out/build-x86_64-linux-musl/execline-v2.9.4.0 && rm -rf $out/build-x86_64-linux-musl/execline-v2.9.4.0/.git
  # chmod -R u+w $out/build-x86_64-linux-musl/execline-v2.9.4.0
  # ln -s ${skaS6} $out/sources/s6
  # cp -r ${skaS6} $out/build-x86_64-linux-musl/s6-v2.12.0.2 && rm -rf $out/build-x86_64-linux-musl/s6-v2.12.0.2/.git
  # chmod -R u+w $out/build-x86_64-linux-musl/s6-v2.12.0.2

  installPhase = ''
    # tried ln -s but that didn't work
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
