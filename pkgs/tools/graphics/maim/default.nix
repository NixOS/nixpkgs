{ stdenv, fetchurl, cmake, gengetopt, imlib2, libXrandr, libXfixes
, cppcheck}:

stdenv.mkDerivation rec {
  name = "maim-${version}";
  version = "3.4.46";

  src = fetchurl {
    url = "https://github.com/naelstrof/maim/archive/v${version}.tar.gz";
    sha256 = "04gb858g0rrvdiva2dxwsfd7dmq62r67irnc8cpd0r02hr92dr6n";
  };

  buildInputs = [ cmake gengetopt imlib2 libXrandr libXfixes ]
                ++ stdenv.lib.optional doCheck cppcheck;

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
