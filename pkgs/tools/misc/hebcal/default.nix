{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "4.15";
  name = "hebcal-${version}";

  src = fetchFromGitHub {
    owner = "hebcal";
    repo = "hebcal";
    rev = "v${version}";
    sha256 = "1s9iardqyzn42hs0x9p4rig2m87v87jvzcrbb9arcci7nds66y3i";
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
