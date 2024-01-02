{ lib
, stdenv
, fetchurl
, buildClient ? true
}:

stdenv.mkDerivation rec {
  srcName = "bsd-finger";
  pname = srcName + lib.optionalString (!buildClient) "d";
  version = "0.17";

  src = fetchurl {
    url = "mirror://ibiblioPubLinux/system/network/finger/${srcName}-${version}.tar.gz";
    hash = "sha256-hIhdZo0RfvUOAccDSkXYND10fOxiEuQOjQgVG8GOE/o=";
  };

  # outputs = [ "out" "man" ];

  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  patches = [
    ./ubuntu-0.17-9.patch
  ];

  preBuild = let
    srcdir = if buildClient then "finger" else "fingerd";
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
    description =
      if buildClient
      then "User information lookup program"
      else "Remote user information server";
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
  };
}
# TODO: multiple outputs (manpage)
