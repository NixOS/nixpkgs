{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation {
  pname = "pikchr";
  # To update, use the last check-in in https://pikchr.org/home/timeline?r=trunk
  version = "unstable-2022-06-20";

  src = fetchurl {
    url = "https://pikchr.org/home/tarball/d9ee756594b6eb64/pikchr.tar.gz";
    sha256 = "sha256-ML+gymFrBay1kly7NYsxo0I1qNMoZPzNI3ClBTrWlHw=";
  };

  # can't open generated html files
  postPatch = ''
    substituteInPlace Makefile --replace open "test -f"
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

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
