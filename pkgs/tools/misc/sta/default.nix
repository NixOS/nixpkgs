{ stdenv, lib, fetchFromGitHub, autoreconfHook }:
stdenv.mkDerivation {
  pname = "sta";
  version = "unstable-2016-01-25";

  src = fetchFromGitHub {
    owner = "simonccarter";
    repo = "sta";
    rev = "2aa2a6035dde88b24978b875e4c45e0e296f77ed";
    sha256 = "05804f106nb89yvdd0csvpd5skwvnr9x4qr3maqzaw0qr055mrsk";
  };

  buildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Simple statistics from the command line interface (CLI), fast";
    longDescription = ''
      This is a lightweight, fast tool for calculating basic descriptive
      statistics from the command line. Inspired by
      https://github.com/nferraz/st, this project differs in that it is written
      in C++, allowing for faster computation of statistics given larger
      non-trivial data sets.
    '';
    license = licenses.mit;
    homepage = "https://github.com/simonccarter/sta";
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.all;
    badPlatforms = platforms.darwin;
  };
}
