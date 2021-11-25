{ lib, stdenv, fetchurl, libv4l, gd }:

stdenv.mkDerivation rec {
  pname = "fswebcam";
  version = "2020-07-25";

  src = fetchurl {
    url = "https://www.sanslogic.co.uk/fswebcam/files/fswebcam-${lib.replaceStrings ["."] [""] version}.tar.gz";
    sha256 = "1dazsrcaw9s30zz3jpxamk9lkff5dkmflp1s0jjjvdbwa0k6k6ii";
  };

  buildInputs =
    [ libv4l gd ];

  meta = {
    description = "Neat and simple webcam app";
    homepage = "http://www.sanslogic.co.uk/fswebcam";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
  };
}
