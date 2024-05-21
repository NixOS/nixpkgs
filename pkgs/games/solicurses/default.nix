{ stdenv
, lib
, fetchFromGitHub
, ncurses
}:

stdenv.mkDerivation {
  pname = "solicurses";
  version = "unstable-2020-02-13";

  src = fetchFromGitHub {
    owner = "KaylaPP";
    repo = "SoliCurses";
    rev = "dc89ca00fc1711dc449d0a594a4727af22fc35a0";
    sha256 = "sha256-zWYXpvEnViT/8gsdMU9Ymi4Hw+nwkG6FT/3h5sNMCE4=";
  };

  buildInputs = [
    ncurses
  ];

  preBuild = ''
    cd build
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}c++"
  ];

  installPhase = ''
    install -D SoliCurses.out $out/bin/solicurses
  '';

  meta = with lib; {
    description = "A version of Solitaire written in C++ using the ncurses library";
    mainProgram = "solicurses";
    homepage = "https://github.com/KaylaPP/SoliCurses";
    maintainers = with maintainers; [ laalsaas ];
    license = licenses.gpl3Only;
    inherit (ncurses.meta) platforms;
  };
}
