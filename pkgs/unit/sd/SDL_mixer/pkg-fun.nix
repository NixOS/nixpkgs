{ stdenv, lib, fetchurl
, SDL, libogg, libvorbis, smpeg, libmikmod
, fluidsynth, pkg-config
, enableNativeMidi ? false
}:

stdenv.mkDerivation rec {
  pname   = "SDL_mixer";
  version = "1.2.12";

  src = fetchurl {
    url    = "http://www.libsdl.org/projects/${pname}/release/${pname}-${version}.tar.gz";
    sha256 = "0alrhqgm40p4c92s26mimg9cm1y7rzr6m0p49687jxd9g6130i0n";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL libogg libvorbis fluidsynth smpeg libmikmod ];

  configureFlags = [ "--disable-music-ogg-shared" "--disable-music-mod-shared" ]
    ++ lib.optional enableNativeMidi " --enable-music-native-midi-gpl"
    ++ lib.optionals stdenv.isDarwin [ "--disable-sdltest" "--disable-smpegtest" ];

  meta = with lib; {
    description = "SDL multi-channel audio mixer library";
    homepage    = "http://www.libsdl.org/projects/SDL_mixer/";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
    license     = licenses.zlib;
  };
}
