{ stdenv, fetchFromGitHub, cmake, qttools, alsaLib }:

stdenv.mkDerivation rec {
  version = "2019-01-12";
  pname = "OPL3BankEditor";

  src = fetchFromGitHub {
    owner = "Wohlstand";
    repo = pname;
    rev = "a254c923df5b385e140de6ae42cf4908af8728d3";
    sha256 = "181zkr2zkv9xy6zijbzqbqf4z6phg98ramzh9hmwi5zcbw68wkqw";
    fetchSubmodules = true;
  };

  buildInputs = [
    alsaLib qttools
  ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A small cross-platform editor of the OPL3 FM banks of different formats";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
