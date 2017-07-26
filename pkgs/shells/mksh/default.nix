{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mksh-${version}";
  version = "55";

  src = fetchurl {
    urls = [
      "http://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R${version}.tgz"
      "http://pub.allbsd.org/MirOS/dist/mir/mksh/mksh-R${version}.tgz"
    ];
    sha256 = "0mssqd2wp3cs9x01v6g66iy3ymdxagbyw2c0v597vnc1l6s2rm6f";
  };

  buildPhase = ''sh ./Build.sh -r -c lto'';

  installPhase = ''
    install -D -m 755 mksh $out/bin/mksh
    install -D -m 644 mksh.1 $out/share/man/man1/mksh.1
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ AndersonTorres nckx joachifm ];
    platforms = platforms.unix;
  };

  passthru = {
    shellPath = "/bin/mksh";
  };
}
