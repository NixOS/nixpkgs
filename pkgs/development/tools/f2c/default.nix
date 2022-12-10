{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "f2c";
  version = "20200916";

  src = fetchurl {
    url = "https://www.netlib.org/f2c/src.tgz";
    sha256 = "0d8xfbv6dk4dz95qds7sd44b5hvara07f2g2c5g4xiwim9b7916l";
  };

  makeFlags = [ "-f" "makefile.u" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/man/man1
    install -m755 f2c $out/bin
    install -m755 xsum $out/bin
    install f2c.1t $out/share/man/man1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Convert Fortran 77 source code to C";
    homepage = "https://www.netlib.org/f2c/";
    license = licenses.mit;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.unix;
  };
}
