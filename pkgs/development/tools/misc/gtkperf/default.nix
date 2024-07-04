{ lib, stdenv, fetchurl, gtk2, pkg-config, libintl }:

stdenv.mkDerivation rec {
  pname = "gtkperf";
  version = "0.40.0";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}_${lib.versions.majorMinor version}.tar.gz";
    sha256 = "0yxj3ap3yfi76vqg6xjvgc16nfi9arm9kp87s35ywf10fd73814p";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 libintl ];

  # https://openbenchmarking.org/innhold/7e9780c11550d09aa67bdba71248facbe2d781db
  patches = [ ./bench.patch ];

  meta = with lib; {
    description = "Application designed to test GTK performance";
    mainProgram = "gtkperf";
    homepage = "https://gtkperf.sourceforge.net/";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ dtzWill ];
  };
}
