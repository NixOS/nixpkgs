{stdenv, libcap}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libcap-progs-${libcap.version}";

  inherit (libcap) src makeFlags;

  buildInputs = [ libcap ];

  preConfigure = "cd progs";

  postInstall = libcap.postinst name;
}
