{ stdenv, fetchFromGitHub, curl, expat
, jansson, libpng, libjpeg, libGLU_combined, pcre
, pkgconfig, SDL2, vimNox }:

stdenv.mkDerivation rec {
  name = pname + "-" + version;
  pname = "ezquake";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "ezQuake";
    repo = pname + "-source";
    rev = "v" + version;
    sha256 = "14wck0r64z5haacp7g7qb2qrbhff3x6jfjmn4268dyb9dl5663f2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    expat curl jansson libpng libjpeg libGLU_combined pcre SDL2 vimNox
  ];

  installPhase = with stdenv.lib; let
    sys = last (splitString "-" stdenv.system);
    arch = head (splitString "-" stdenv.system);
  in ''
    mkdir -p $out/bin
    find .
    mv ezquake-${sys}-${arch} $out/bin/ezquake
  '';

  meta = with stdenv.lib; {
    homepage = http://ezquake.github.io/;
    description = "A modern QuakeWorld client focused on competitive online play.";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edwtjo ];
  };
}
