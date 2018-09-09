{ stdenv, fetchFromGitLab }:

stdenv.mkDerivation rec {
  name = "bunny-${version}";
  version = "1.2";

  src = fetchFromGitLab {
    owner = "tim241";
    repo = "bunny";
    rev = version;
    sha256 = "13qsgv4n4c96pgm2l5kvwxpk97x2jpk3wp2m56vdj07hcgywgj3h";
  };

  dontBuild = true;

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "A simple shell script wrapper around multiple package managers";
    homepage = https://gitlab.com/tim241/bunny;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ countingsort ];
  };
}
