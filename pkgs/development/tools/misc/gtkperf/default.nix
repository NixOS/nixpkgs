{ stdenv, fetchurl, gtk2, pkgconfig, libintl }:

stdenv.mkDerivation {
  name = "gtkperf-0.40.0";
  src = fetchurl {
    url = "mirror://sourceforge//gtkperf/gtkperf_0.40.tar.gz";
    sha256 = "0yxj3ap3yfi76vqg6xjvgc16nfi9arm9kp87s35ywf10fd73814p";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 libintl ];

  meta = with stdenv.lib; {
    description = "Application designed to test GTK+ performance";
    homepage = http://gtkperf.sourceforge.net/;
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ dtzWill ];
  };
}
