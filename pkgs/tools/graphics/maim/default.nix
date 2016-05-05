{ stdenv, fetchurl, cmake, gengetopt, imlib2, libXrandr, libXfixes }:

stdenv.mkDerivation rec {
  name = "maim-${version}";
  version = "3.4.47";

  src = fetchurl {
    url = "https://github.com/naelstrof/maim/archive/v${version}.tar.gz";
    sha256 = "0kfp7k55bxc5h6h0wv8bwmsc5ny66h9ra2z4dzs4yzszq16544pv";
  };

  buildInputs = [ cmake gengetopt imlib2 libXrandr libXfixes ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/naelstrof/maim;
    description = "A command-line screenshot utility";
    longDescription = ''
      maim (make image) takes screenshots of your desktop. It has options to
      take only a region, and relies on slop to query for regions. maim is
      supposed to be an improved scrot.
    '';
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with maintainers; [ mbakke ];
  };
}
