{ stdenv, fetchFromGitHub, SDL2, wxGTK } :

stdenv.mkDerivation rec {

  pname = "sound-of-sorting";
  version = "2017-12-23";

  src = fetchFromGitHub {
    owner = "bingmann";
    repo = "sound-of-sorting";
    rev = "5884a357af5775fb57d89eb028d4bf150760db75";
    sha256 = "01bpzn38cwn9zlydzvnfz9k7mxdnjnvgnbcpx7i4al8fha7x9lw8";
  };

  buildInputs = 
  [ wxGTK SDL2 ];

  preConfigure = ''
    export SDL_CONFIG=${SDL2.dev}/bin/sdl2-config
  '';

  meta = with stdenv.lib; {
    description = "Audibilization and Visualization of Sorting Algorithms";
    homepage = "http://panthema.net/2013/sound-of-sorting/";
    license = with licenses; gpl3;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
