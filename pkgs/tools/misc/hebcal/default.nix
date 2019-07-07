{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "4.18";
  name = "hebcal-${version}";

  src = fetchFromGitHub {
    owner = "hebcal";
    repo = "hebcal";
    rev = "v${version}";
    sha256 = "13b3gbfl043s6vycf5kdy2lkchy3kg690vy0dpmy3si6x05nl10w";
  };

  nativeBuildInputs = [ autoreconfHook ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://hebcal.github.io;
    description = "A perpetual Jewish Calendar";
    longDescription = "Hebcal is a program which prints out the days in the Jewish calendar for a given Gregorian year. Hebcal is fairly flexible in terms of which events in the Jewish calendar it displays.";
    license = licenses.gpl2;
    maintainers = [ maintainers.hhm ];
    platforms = platforms.all;
  };
}
