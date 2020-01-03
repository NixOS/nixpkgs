{ stdenv, mkDerivation, fetchFromGitHub, cmake, qttools, alsaLib }:

mkDerivation rec {
  version = "1.5";
  pname = "OPL3BankEditor";

  src = fetchFromGitHub {
    owner = "Wohlstand";
    repo = pname;
    rev = "v${version}";
    sha256 = "16va5xfbyn2m63722ab5yph0l7kmghkbk6dkia93041mfhdyg9rc";
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
