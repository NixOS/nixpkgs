{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "snow";
  version = "20130616";

  src = fetchurl {
    url = "https://web.archive.org/web/20200304125913if_/http://darkside.com.au/snow/snow-${version}.tar.gz";
    sha256 = "0r9q45y55z4i0askkxmxrx0jr1620ypd870vz0hx2a6n9skimdy0";
  };

  makeFlags = [ "CFLAGS=-O2" ];

  installPhase = ''
    install -Dm755 snow -t $out/bin
  '';

  meta = with lib; {
    description = "Conceal messages in ASCII text by appending whitespace to the end of lines";
    homepage = "http://www.darkside.com.au/snow/";
    license = licenses.asl20;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
