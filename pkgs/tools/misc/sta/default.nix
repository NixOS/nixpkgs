{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation {
  pname = "sta";
  version = "unstable-2020-05-10";

  src = fetchFromGitHub {
    owner = "simonccarter";
    repo = "sta";
    rev = "566e3a77b103aa27a5f77ada8e068edf700f26ef";
    sha256 = "1v20di90ckl405rj5pn6lxlpxh2m2b3y9h2snjvk0k9sihk7w7d5";
  };

  nativeBuildInputs = [ autoreconfHook ];

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
