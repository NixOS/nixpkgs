{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "4.16";
  name = "hebcal-${version}";

  src = fetchFromGitHub {
    owner = "hebcal";
    repo = "hebcal";
    rev = "v${version}";
    sha256 = "081h3dan0v14camv6j3swl9y31yzfwjfkp2h8xz5qmrh0scv8azr";
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
