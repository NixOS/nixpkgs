{ stdenv, fetchurl, groff }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "mksh-${version}";
  version = "R50d";

  src = fetchurl {
    urls = [
      "http://www.mirbsd.org/MirOS/dist/mir/mksh/${name}.tgz"
      "http://pub.allbsd.org/MirOS/dist/mir/mksh/${name}.tgz"
    ];
    sha256 = "10prcdffwziksq9sw96c1r09h4kg2zwznybrggzmjfa6l4k8h9m2";
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

  meta = {
    description = "MirBSD Korn Shell";
    longDescription = ''
      The MirBSD Korn Shell is a DFSG-free and OSD-compliant (and OSI
      approved) successor to pdksh, developed as part of the MirOS
      Project as native Bourne/POSIX/Korn shell for MirOS BSD, but
      also to be readily available under other UNIX(R)-like operating
      systems.
    '';
    homepage = "https://www.mirbsd.org/mksh.htm";
    licenses = "custom";
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
