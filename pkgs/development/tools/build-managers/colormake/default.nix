{ lib, stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation {
  pname = "colormake";
  version = "2.1.0";

  buildInputs = [ perl ];

  src = fetchFromGitHub {
    owner = "pagekite";
    repo = "Colormake";
    rev = "66544f40d";
    sha256 = "8e714c5540305d169989d9387dbac47b8b9fb2cfb424af7bcd412bfe684dc6d7";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -fa colormake.pl colormake colormake-short clmake clmake-short $out/bin
  '';

  meta = with lib; {
    description = "Simple wrapper around make to colorize the output";
    homepage = "https://bre.klaki.net/programs/colormake/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bhipple ];
  };
}
