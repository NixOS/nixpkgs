{ stdenv, fetchurl
, SDL2, wxGTK
}:

stdenv.mkDerivation rec {

  name = "sound-of-sorting-${version}";
  version = "0.6.5";

  src = fetchurl {
    url = "https://github.com/bingmann/sound-of-sorting/archive/${name}.tar.gz";
    sha256 = "1524bhmy5067z9bjc15hvqslw43adgpdn4272iymq09ahja4x76b";
  };

  buildInputs = with stdenv.lib;
  [ wxGTK SDL2 ];

  preConfigure = ''
    export SDL_CONFIG=${SDL2}/bin/sdl2-config
  '';

  meta = with stdenv.lib;{
    description = "Audibilization and Visualization of Sorting Algorithms";
    homepage = http://panthema.net/2013/sound-of-sorting/;
    license = licenses.gpl3;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
