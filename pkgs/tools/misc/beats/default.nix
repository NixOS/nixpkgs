{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "beats";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "j0hax";
    repo = "beats";
    rev = "v${version}";
    sha256 = "0qs5cmbncqhs11m4whqmrh2gvv3p3b37qz57xh78x2ma8jbhskqz";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/j0hax/beats";
    license = licenses.gpl3Only;
    description = "Swatch Internet Time implemented as a C program";
    platforms = platforms.all;
    maintainers = [ maintainers.j0hax ];
  };
}
