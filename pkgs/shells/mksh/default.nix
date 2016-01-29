{ stdenv, fetchurl, groff }:

stdenv.mkDerivation rec {
  name = "mksh-${version}";
  version = "52";

  src = fetchurl {
    urls = [
      "http://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R${version}.tgz"
      "http://pub.allbsd.org/MirOS/dist/mir/mksh/mksh-R${version}.tgz"
    ];
    sha256 = "13vnncwfx4zq3yi7llw3p6miw0px1bm5rrps3y1nlfn6sb6zbhj5";
  };

  buildInputs = [ groff ];

  buildPhase = ''
    mkdir build-dir/
    cp mksh.1 dot.mkshrc build-dir/
    cd build-dir/
    sh ../Build.sh -c lto
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1 $out/share/mksh $out/bin
    install -D -m 755 mksh $out/bin/mksh
    install -D -m 644 mksh.1 $out/share/man/man1/mksh.1
    install -D -m 644 mksh.cat1 $out/share/mksh/mksh.cat1
    install -D -m 644 dot.mkshrc $out/share/mksh/mkshrc
  '';

  meta = with stdenv.lib; {
    description = "MirBSD Korn Shell";
    longDescription = ''
      The MirBSD Korn Shell is a DFSG-free and OSD-compliant (and OSI
      approved) successor to pdksh, developed as part of the MirOS
      Project as native Bourne/POSIX/Korn shell for MirOS BSD, but
      also to be readily available under other UNIX(R)-like operating
      systems.
    '';
    homepage = "https://www.mirbsd.org/mksh.htm";
    license = licenses.free;
    maintainers = with maintainers; [ AndersonTorres nckx ];
    platforms = platforms.unix;
  };
}
