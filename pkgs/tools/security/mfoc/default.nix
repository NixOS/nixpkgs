{ stdenv, fetchurl, pkgconfig, libnfc }:

stdenv.mkDerivation rec {
  name = "mfoc-${version}";
  version = "0.10.6";

  src = fetchurl {
    url = "http://mfoc.googlecode.com/files/${name}.tar.gz";
    sha1 = "3adce3029dce9124ff3bc7d0fad86fa0c374a9e3";
  };

  patches = [./mf_mini.patch];

  buildInputs = [ pkgconfig libnfc ];

  meta = with stdenv.lib; {
    description = "Mifare Classic Offline Cracker";
    license = licenses.gpl2;
    homepage = http://code.google.com/p/mfoc/;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
