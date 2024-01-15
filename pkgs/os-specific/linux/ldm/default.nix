{ lib, stdenv, fetchgit, udev, util-linux, mountPath ? "/media/" }:

assert mountPath != "";

let
  version = "0.5";
in
stdenv.mkDerivation rec {
  pname = "ldm";
  inherit version;

  # There is a stable release, but we'll use the lvm branch, which
  # contains important fixes for LVM setups.
  src = fetchgit {
    url = "https://github.com/LemonBoy/ldm";
    rev = "refs/tags/v${version}";
    sha256 = "0lxfypnbamfx6p9ar5k9wra20gvwn665l4pp2j4vsx4yi5q7rw2n";
  };

  buildInputs = [ udev util-linux ];

  postPatch = ''
    substituteInPlace ldm.c \
      --replace "/mnt/" "${mountPath}"
    sed '16i#include <sys/stat.h>' -i ldm.c
  '';

  buildFlags = [ "ldm" ];

  installPhase = ''
    mkdir -p $out/bin
    cp -v ldm $out/bin
  '';

  meta = {
    description = "A lightweight device mounter, with libudev as only dependency";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
