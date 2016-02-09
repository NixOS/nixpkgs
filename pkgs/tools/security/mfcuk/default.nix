{ stdenv, fetchurl, pkgconfig, libnfc }:

stdenv.mkDerivation rec {
  name = "mfcuk-${version}";
  version = "0.3.8";

  src = fetchurl {
    url = "http://mfcuk.googlecode.com/files/mfcuk-0.3.8.tar.gz";
    sha256 = "0m9sy61rsbw63xk05jrrmnyc3xda0c3m1s8pg3sf8ijbbdv9axcp";
  };

  buildInputs = [ pkgconfig libnfc ];

  meta = with stdenv.lib; {
    description = "MiFare Classic Universal toolKit";
    license = licenses.gpl2;
    homepage = http://code.google.com/p/mfcuk/;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
