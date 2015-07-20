{ stdenv, fetchurl, groff }:

let version = "51"; in
stdenv.mkDerivation {
  name = "mksh-${version}";

  src = fetchurl {
    urls = [
      "http://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R${version}.tgz"
      "http://pub.allbsd.org/MirOS/dist/mir/mksh/mksh-R${version}.tgz"
    ];
    sha256 = "1pyscl3w4aw067a5hb8mczy3z545jz1dwx9n2b09k09xydgsmvlz";
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
    inherit version;
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
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
