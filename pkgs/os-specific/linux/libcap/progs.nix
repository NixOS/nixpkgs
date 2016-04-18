{stdenv, libcap}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libcap-progs-${libcap.version}";

  inherit (libcap) src makeFlags;

  buildInputs = [ libcap ];

  prePatch = ''
    # use relative bash path
    substituteInPlace progs/capsh.c --replace "/bin/bash" "bash"

    # ensure capsh can find bash in $PATH
    substituteInPlace progs/capsh.c --replace execve execvpe
  '';

  preConfigure = "cd progs";

  installFlags = "RAISE_SETFCAP=no";

  postInstall = ''
    mkdir -p "$out/share/doc/${name}"
    cp ../License "$out/share/doc/${name}/"
  '';
}
