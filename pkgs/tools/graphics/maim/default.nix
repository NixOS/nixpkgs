{ stdenv, fetchurl, cmake, gengetopt, imlib2, libXrandr, libXfixes
, cppcheck}:

stdenv.mkDerivation rec {
  name = "maim-${version}";
  version = "3.3.41";

  src = fetchurl {
    url = "https://github.com/naelstrof/maim/archive/v${version}.tar.gz";
    sha256 = "12p9zd4skxds26hicy6hrxkxnhbqv1c5ys1h6jchaypvwdggcgnc";
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
