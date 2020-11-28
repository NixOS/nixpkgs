{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "4.22";
  pname = "hebcal";

  src = fetchFromGitHub {
    owner = "hebcal";
    repo = "hebcal";
    rev = "v${version}";
    sha256 = "0bm29n51qi9q4vx4qsz3l9l1wvpvsk138zixfl5f5yz4kngzbx24";
  };

  nativeBuildInputs = [ autoreconfHook ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://hebcal.github.io";
    description = "A perpetual Jewish Calendar";
    longDescription = "Hebcal is a program which prints out the days in the Jewish calendar for a given Gregorian year. Hebcal is fairly flexible in terms of which events in the Jewish calendar it displays.";
    license = licenses.gpl2;
    maintainers = [ maintainers.hhm ];
    platforms = platforms.all;
  };
}
