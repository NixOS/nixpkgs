{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation {
  pname = "pikchr";
  version = "unstable-2021-04-07";

  src = fetchurl {
    url = "https://pikchr.org/home/tarball/90b6d5b4a3834ff0/pikchr.tar.gz";
    sha256 = "1cqpnljy12gl82rcbb7mwhgv9szcliwkbwwh67hzdv020h1scxym";
  };

  # can't open generated html files
  postPatch = ''
    substituteInPlace Makefile --replace open "test -f"
  '';

  installPhase = ''
    install -Dm755 pikchr $out/bin/pikchr
    install -Dm755 pikchr.out $out/lib/pikchr.o
    install -Dm644 pikchr.h $out/include/pikchr.h
  '';

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    description = "A PIC-like markup language for diagrams in technical documentation";
    homepage = "https://pikchr.org";
    license = licenses.bsd0;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
