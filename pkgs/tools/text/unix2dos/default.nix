{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "unix2dos-2.2";
  
  src = fetchurl {
    url = http://cvs.fedoraproject.org/repo/pkgs/unix2dos/unix2dos-2.2.src.tar.gz/e4488c241fa9067a48a7534a21d4babb/unix2dos-2.2.src.tar.gz;
    md5 = "e4488c241fa9067a48a7534a21d4babb";
  };

  patches = [
    ./unix2dos-mkstemp.patch
    ./unix2dos-2.2-segfault.patch
    ./unix2dos-2.2-manpage.patch
    ./unix2dos-2.2-mode.patch
    ./unix2dos-2.2-tmppath.patch
    ./unix2dos-preserve-file-modes.patch
  ];

  sourceRoot = ".";

  buildPhase = ''
    cc -o unix2dos unix2dos.c
  '';

  installPhase = ''
    ensureDir $out/bin
    ensureDir $out/share/man
    install -p -m755 unix2dos $out/bin
    install -p -m444 unix2dos.1 $out/share/man
  '';

  meta = {
    homepage = http://unknown/;
    description = "unix2dos tool";
  };
}
