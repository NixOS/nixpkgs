{ baseName ? "corsix-th", version ? "trunk", audioSupport ? true, movieSupport ? true, freetypeSupport ? true, buildDocs ? false, enableUnitTests ? false, stdenv, cmake, lib, githubSource, SDL2, lua5_3, makeWrapper, SDL2_mixer, soundfont-fluid, fluidsynth, ffmpeg, freetype, doxygen, catch2 }:

with lib;

let
  lua = {
    env = lua5_3.withPackages (ps: with ps; [ lpeg luafilesystem ]);
    packageDir = "${lua.env.outPath}/lib/lua/5.3";
  };

  SDL2_mixer_fluid =
    if audioSupport then
      SDL2_mixer.overrideAttrs
        (old: rec {
          configureFlags = old.configureFlags ++ [
            " --enable-music-midi-fluidsynth-shared"
            " --disable-music-midi-timidity"
          ];
        }) else null;
in
stdenv.mkDerivation rec {
  inherit version;

  pname = baseName;

  src = githubSource;

  nativeBuildInputs = [ cmake makeWrapper ];

  buildInputs = [ lua.env SDL2 ]
    ++ optional audioSupport SDL2_mixer_fluid
    ++ optionals (audioSupport && stdenv.isLinux) [ soundfont-fluid fluidsynth ]
    ++ optional freetypeSupport freetype
    ++ optional movieSupport ffmpeg
    ++ optional buildDocs doxygen
    ++ optional enableUnitTests catch2;

  cmakeFlags = [
    "-DLUA_DIR=${lua.env}"
    "-DLUA_PACKAGES_DIR=${lua.packageDir}"
    "-DSDL_LIBRARY=${SDL2}/lib/libSDL2.so"
    "-DSDL_INCLUDE_DIR=${SDL2.dev}/include/SDL2"

    "-DFFMPEG_DIR=${optionalString movieSupport ffmpeg}"
    "-DFREETYPE_DIR=${optionalString freetypeSupport freetype}"
    "-DSDL_MIXER_DIR=${optionalString audioSupport SDL2_mixer}"
  ]
  ++ optional (!audioSupport) "-DWITH_AUDIO=OFF"
  ++ optional (!freetypeSupport) "-DWITH_FREETYPE2=OFF"
  ++ optional (!movieSupport) "-DWITH_MOVIES=OFF"
  ++ optional enableUnitTests "-DENABLE_UNIT_TESTS=ON";

  preFixup = ''
    cp -a "${lua.packageDir}"/. $out/share/corsix-th/
  '';

  postInstall = ''
    mkdir -p $out/share/bin
    mv $out/bin/${baseName} $out/share/bin
    makeWrapper $out/share/bin/${baseName} $out/bin/${baseName} \
      --set SDL_SOUNDFONTS ${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2
  '';

  meta = with lib; {
    description = "Open source clone of Theme Hospital";
    longDescription = "A reimplementation of the 1997 Bullfrog business sim Theme Hospital. As well as faithfully recreating the original, CorsixTH adds support for modern operating systems (Windows, macOS, Linux and BSD), high resolutions and much more.";
    homepage = "https://github.com/CorsixTH/CorsixTH";
    maintainers = with maintainers; [ alexandre-lavoie ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
