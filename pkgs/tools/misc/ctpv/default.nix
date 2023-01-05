{ lib, stdenv, fetchurl, file, openssl, imagemagick }:

stdenv.mkDerivation rec {
  pname = "ctpv";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/NikitaIvanovV/${pname}/archive/refs/tags/v${version}.tar.gz";
    sha256 = "0kgrxdi3l2lf4bq9nmp7c7kwd8zbzdc0rq5jvypsm7a3yw0vn4fs";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ctpv $out/bin/ctpv
  '';

  buildInputs = [ file openssl imagemagick ];

  meta = with lib; {
    homepage = "https://github.com/NikitaIvanovV/ctpv";
    description = "A previewer utility for terminals";

    license = licenses.mit;

    platforms = platforms.unix;
    maintainers = with maintainers; [ snglth ];
  };
}
