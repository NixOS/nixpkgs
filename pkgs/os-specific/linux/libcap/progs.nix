{stdenv, libcap}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libcap-progs-${libcap.version}";

  inherit (libcap) src makeFlags;

  buildInputs = [ libcap ];

  patches = [ ./progs-bash-path.patch ];

  preConfigure = "cd progs";

  installFlags = "RAISE_SETFCAP=no";

  postInstall = libcap.postinst name;
}
