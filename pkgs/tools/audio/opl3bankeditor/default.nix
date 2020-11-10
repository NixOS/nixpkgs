{ stdenv, mkDerivation, fetchFromGitHub, cmake, qttools, alsaLib }:

mkDerivation rec {
  version = "1.5.1";
  pname = "OPL3BankEditor";

  src = fetchFromGitHub {
    owner = "Wohlstand";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g59qrkcm4xnyxx0s2x28brqbf2ix6vriyx12pcdvfhhcdi55hxh";
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
