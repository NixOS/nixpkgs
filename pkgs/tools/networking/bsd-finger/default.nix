{ lib, stdenv, fetchurl, buildClient ? true }:

stdenv.mkDerivation rec {
  srcName = "bsd-finger";
  pname = srcName + lib.optionalString (!buildClient) "d";
  version = "0.17";

  src = fetchurl {
    url =
      "http://ftp.de.debian.org/debian/pool/main/b/bsd-finger/bsd-finger_${version}.orig.tar.bz2";
    hash = "sha256-KLNNYF0j6mh9eeD8SMA1q+gPiNnBVH56pGeW0QgcA2M=";
  };

  # outputs = [ "out" "man" ];

  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  patches = [
    ./01-legacy.patch
    ./02-518559-nsswitch-sources.patch
    ./03-468454-fingerd-ipv6.patch
    ./04-468454-finger-ipv6.patch
    ./05-547014-netgroup.patch
    ./06-572211-decrease-timeout.patch
    ./use-cmake-as-buildsystem.patch
    ./use-cmake-as-buildsystem-debian-extras.patch
    ./fix-fingerd-man-typo.patch
  ];

  preBuild = let srcdir = if buildClient then "finger" else "fingerd";
  in ''
    cd ${srcdir}
  '';

  preInstall = let
    bindir = if buildClient then "bin" else "sbin";
    mandir = if buildClient then "man/man1" else "man/man8";
  in ''
    mkdir -p $out/${bindir} $out/${mandir}
  '';

  meta = with lib; {
    description = if buildClient then
      "User information lookup program"
    else
      "Remote user information server";
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
    mainProgram = "finger";
  };
}
# TODO: multiple outputs (manpage)
