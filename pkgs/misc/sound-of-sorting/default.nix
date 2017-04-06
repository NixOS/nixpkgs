{ stdenv, fetchgit
, SDL2, wxGTK }:

stdenv.mkDerivation rec {

  name = "sound-of-sorting-${version}";
  version = "unstable-2015-07-21";

  src = fetchgit {
    url = "https://github.com/bingmann/sound-of-sorting.git";
    rev = "05db428c796a7006d63efdbe314f976e0aa881d6";
    sha256 = "0m2f1dym3hcar7784sjzkbf940b28r02ajhkjgyyw7715psifb8l";
    fetchSubmodules = true;
  };

  buildInputs = with stdenv.lib;
  [ wxGTK SDL2 ];

  preConfigure = ''
    export SDL_CONFIG=${SDL2.dev}/bin/sdl2-config
  '';

  meta = with stdenv.lib;{
    description = "Audibilization and Visualization of Sorting Algorithms";
    homepage = http://panthema.net/2013/sound-of-sorting/;
    license = with licenses; gpl3;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
