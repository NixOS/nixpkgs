{stdenv, libcap}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libcap-docs-${libcap.version}";

  inherit (libcap) src;

  makeFlags = "MANDIR=$(out)/share/man";

  preConfigure = "cd doc";
}
