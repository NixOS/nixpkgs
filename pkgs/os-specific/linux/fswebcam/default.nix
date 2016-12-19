{ stdenv, fetchurl, libv4l, gd }:

stdenv.mkDerivation rec {
  name = "fswebcam-20140113";

  src = fetchurl {
    url = "http://www.sanslogic.co.uk/fswebcam/files/${name}.tar.gz";
    sha256 = "3ee389f72a7737700d22e0c954720b1e3bbadc8a0daad6426c25489ba9dc3199";
  };

  buildInputs =
    [ libv4l gd ];

  meta = {
    description = "Neat and simple webcam app";
    homepage = http://www.sanslogic.co.uk/fswebcam;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
