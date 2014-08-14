{ stdenv, fetchurl, unzip, jre }:

stdenv.mkDerivation rec {
  name = "jdiskreport-1.4.1";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://www.jgoodies.com/download/jdiskreport/jdiskreport-1_4_1.zip;
    sha256 = "0d5mzkwsbh9s9b1vyvpaawqc09b0q41l2a7pmwf7386b1fsx6d58";
  };

  buildInputs = [ unzip ];

  inherit jre;

  meta = {
    homepage = http://www.jgoodies.com/freeware/jdiskreport/;
    description = "A graphical utility to visualize disk usage";
    license = "unfree-redistributable"; #TODO freedist, libs under BSD-3
  };
}
