{stdenv, libcap}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libcap-progs-${libcap.version}";

  inherit (libcap) src makeFlags;

  buildInputs = [ libcap ];

  prePatch = ''
    BASH=$(type -tp bash)
    substituteInPlace progs/capsh.c --replace "/bin/bash" "$BASH"
  '';

  preConfigure = "cd progs";

  installFlags = "RAISE_SETFCAP=no";

  postInstall = libcap.postinst name;
}
