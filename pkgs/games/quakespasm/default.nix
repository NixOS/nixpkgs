{ lib, stdenv, SDL, SDL2, fetchurl, gzip, libvorbis, libmad
, Cocoa, CoreAudio, CoreFoundation, IOKit, OpenGL
, useSDL2 ? stdenv.isDarwin # TODO: CoreAudio fails to initialize with SDL 1.x for some reason.
}@args:

let
  macFrameworkNames = [
    "Cocoa" "CoreAudio" "IOKit" "OpenGL"
  ] ++ lib.optionals useSDL2 [
    "CoreFoundation"
  ];
  macFrameworks = map (f: args.${f}) macFrameworkNames;
in
stdenv.mkDerivation rec {
  pname = "quakespasm";
  majorVersion = "0.93";
  version = "${majorVersion}.2";

  src = fetchurl {
    url = "mirror://sourceforge/quakespasm/quakespasm-${version}.tgz";
    sha256 = "0qm0j5drybvvq8xadfyppkpk3rxqsxbywzm6iwsjwdf0iia3gss5";
  };

  sourceRoot = "${pname}-${version}/Quake";

  buildInputs = [
    gzip libvorbis libmad (if useSDL2 then SDL2 else SDL)
  ] ++ lib.optionals stdenv.isDarwin macFrameworks;

  CFLAGS = lib.optionalString stdenv.isDarwin "-DGL_SILENCE_DEPRECATION";
  buildFlags = [ "DO_USERDIRS=1" ]
    ++ lib.optional useSDL2 "USE_SDL2=1";

  # NOTE: for macOS, we're using generic Makefile instead of Makefile.darwin, since we are not going to build an app bundle.
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile --replace "-lGL" "${lib.concatMapStringsSep " " (e: "-Wl,-framework,${e}") macFrameworkNames}"
  '' + lib.optionalString (useSDL2 && stdenv.isDarwin) ''
    # SDL 2.x does not replace main() and since we're not going to build an app bundle for macOS, then there is no launcher to call SDL_main.
    substituteInPlace main_sdl.c --replace "#define main SDL_main" ""
  '' + lib.optionalString useSDL2 ''
    substituteInPlace Makefile --replace "sdl-config" "sdl2-config"
  '';

  preInstall = ''
    mkdir -p "$out/bin"
    substituteInPlace Makefile --replace "/usr/local/games" "$out/bin"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "An engine for iD software's Quake";
    homepage = "http://quakespasm.sourceforge.net/";
    longDescription = ''
      QuakeSpasm is a modern, cross-platform Quake 1 engine based on FitzQuake.
      It includes support for 64 bit CPUs and custom music playback, a new sound driver,
      some graphical niceities, and numerous bug-fixes and other improvements.
      Quakespasm utilizes either the SDL or SDL2 frameworks, so choose which one
      works best for you. SDL is probably less buggy, but SDL2 has nicer features
      and smoother mouse input - though no CD support.
    '';

    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ m3tti ];
  };
}
