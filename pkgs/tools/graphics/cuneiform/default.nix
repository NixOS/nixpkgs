{ stdenv, fetchbzr, cmake, patchelf, imagemagick }:

stdenv.mkDerivation rec {
  name = "cuneiform-${version}";
  version = "1.1.0";

  src = fetchbzr {
    url = "lp:~f0ma/cuneiform-linux/devel";
    rev = "540";
    sha256 = "0sj7v3plf2rrc2vzxl946h9yfribc0jfn4b3ffppghxk2g6kicsb";
  };

  buildInputs = [
    cmake imagemagick
  ];

  meta = {
    description = "Multi-language OCR system";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
  };
}
