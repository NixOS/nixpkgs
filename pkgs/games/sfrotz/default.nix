{ fetchFromGitLab
, freetype
, libao
, libjpeg
, libmodplug
, libpng
, libsamplerate
, libsndfile
, libvorbis
, pkg-config
, SDL2
, SDL2_mixer
, lib, stdenv
, zlib }:

stdenv.mkDerivation rec {
  pname = "sfrotz";
  version = "2.54";

  src = fetchFromGitLab  {
    domain = "gitlab.com";
    owner = "DavidGriffith";
    repo = "frotz";
    rev = version;
    sha256 = "sha256-GvGxojD8d5GVy/d8h3q6K7KJroz2lsKbfE0F0acjBl8=";
  };

  buildInputs = [
    freetype
    libao
    libjpeg
    libmodplug
    libpng
    libsamplerate
    libsndfile
    libvorbis
    SDL2
    SDL2_mixer
    zlib
  ];
  nativeBuildInputs = [ pkg-config ];
  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  buildPhase = "make sdl";
  installTargets = [ "install_sfrotz" ];

  meta = with lib; {
    description =
      "Interpreter for Infocom and other Z-Machine games (SDL interface)";
    mainProgram = "sfrotz";
    longDescription = ''
      Frotz is a Z-Machine interpreter. The Z-machine is a virtual machine
      designed by Infocom to run all of their text adventures. It went through
      multiple revisions during the lifetime of the company, and two further
      revisions (V7 and V8) were created by Graham Nelson after the company's
      demise. The specification is now quite well documented; this version of
      Frotz supports version 1.0.

      This version of Frotz fully supports all these versions of the Z-Machine
      including the graphical version 6. Graphics and sound are created through
      the use of the SDL libraries. AIFF sound effects and music in MOD and OGG
      formats are supported when packaged in Blorb container files or optionally
      from individual files.
    '';
    homepage = "https://davidgriffith.gitlab.io/frotz/";
    changelog = "https://gitlab.com/DavidGriffith/frotz/-/raw/${version}/NEWS";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ddelabru ];
    platforms = platforms.linux;
  };
}
