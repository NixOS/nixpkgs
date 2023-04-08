{ lib
, stdenv
, fetchFromGitHub

, SDL2
, cmake
, curl
, discord-rpc
, duktape
, flac
, fontconfig
, freetype
, gbenchmark
, icu
, jansson
, libGLU
, libiconv
, libogg
, libpng
, libpthreadstubs
, libvorbis
, libzip
, nlohmann_json
, openssl
, pkg-config
, speexdsp
, zlib
}:

let
  openrct2-version = "0.4.4";

  # Those versions MUST match the pinned versions within the CMakeLists.txt
  # file. The REPLAYS repository from the CMakeLists.txt is not necessary.
  objects-version = "1.3.8";
  openmsx-version = "1.1.0";
  opensfx-version = "1.0.2";
  title-sequences-version = "0.4.0";

  openrct2-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    rev = "v${openrct2-version}";
    sha256 = "sha256-kCGX+L3bXAG9fUjv04T9wV+R20kmmuREHY8h0w+CESg=";
  };

  objects-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "objects";
    rev = "v${objects-version}";
    sha256 = "sha256-7fKv2dSsWJ/YIneyVeuPMjdNI/kgJ7zkMoAgV/s240w=";
  };

  openmsx-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenMusic";
    rev = "v${openmsx-version}";
    sha256 = "sha256-SqTYJSst1tgVot/c4seuPQVoxnqWiM2Jb/pP3mHtkKs=";
  };

  opensfx-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenSoundEffects";
    rev = "v${opensfx-version}";
    sha256 = "sha256-AMuCpq1Hszi2Vikto/cX9g81LwBDskaRMTLxNzU0/Gk=";
  };

  title-sequences-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "title-sequences";
    rev = "v${title-sequences-version}";
    sha256 = "sha256-anqCZkhYoaxPu3MYCYSsFFngOmPp2wnx2MGb0hj6W5U=";
  };
in
stdenv.mkDerivation {
  pname = "openrct2";
  version = openrct2-version;

  src = openrct2-src;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    curl
    discord-rpc
    duktape
    flac
    fontconfig
    freetype
    gbenchmark
    icu
    jansson
    libGLU
    libiconv
    libogg
    libpng
    libpthreadstubs
    libvorbis
    libzip
    nlohmann_json
    openssl
    speexdsp
    zlib
  ];

  cmakeFlags = [
    "-DDOWNLOAD_OBJECTS=OFF"
    "-DDOWNLOAD_OPENMSX=OFF"
    "-DDOWNLOAD_OPENSFX=OFF"
    "-DDOWNLOAD_TITLE_SEQUENCES=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=maybe-uninitialized"
  ];

  postUnpack = ''
    mkdir -p $sourceRoot/data/assetpack

    cp -r ${objects-src}         $sourceRoot/data/object
    cp -r ${openmsx-src}         $sourceRoot/data/assetpack/openrct2.music.alternative.parkap
    cp -r ${opensfx-src}         $sourceRoot/data/assetpack/openrct2.sound.parkap
    cp -r ${title-sequences-src} $sourceRoot/data/sequence
  '';

  preConfigure =
    # Verify that the correct version of each third party repository is used.
    (let
      versionCheck = cmakeKey: version: ''
        grep -q '^set(${cmakeKey}_VERSION "${version}")$' CMakeLists.txt \
          || (echo "${cmakeKey} differs from expected version!"; exit 1)
      '';
    in
    (versionCheck "OBJECTS" objects-version) +
    (versionCheck "OPENMSX" openmsx-version) +
    (versionCheck "OPENSFX" opensfx-version) +
    (versionCheck "TITLE_SEQUENCE" title-sequences-version)) +

    # Fixup FS rights for the cmake setup-hook in the OPENMSX subsystem
    ''
      chmod -R +w ./data/assetpack/openrct2.music.alternative.parkap/musictools
    '';

  preFixup = "ln -s $out/share/openrct2 $out/bin/data";

  meta = with lib; {
    description = "Open source re-implementation of RollerCoaster Tycoon 2 (original game required)";
    homepage = "https://openrct2.io/";
    downloadPage = "https://github.com/OpenRCT2/OpenRCT2/releases";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oxzi ];
  };
}
