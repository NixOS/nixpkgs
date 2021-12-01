{ lib, stdenv, fetchFromGitHub
, SDL2, cmake, curl, duktape, fontconfig, freetype, icu, jansson, libGLU
, libiconv, libpng, libpthreadstubs, libzip, nlohmann_json, openssl, pkg-config
, speexdsp, zlib
}:

let
  openrct2-version = "0.3.5.1";

  # Those versions MUST match the pinned versions within the CMakeLists.txt
  # file. The REPLAYS repository from the CMakeLists.txt is not necessary.
  objects-version = "1.0.21";
  title-sequences-version = "0.1.2c";

  openrct2-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    rev = "v${openrct2-version}";
    sha256 = "01v9nsabqjq8hjmyshcp7f5liagfq8sxx9i3yqqab7zk4iixag1h";
  };

  objects-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "objects";
    rev = "v${objects-version}";
    sha256 = "0r2vp2y67jc1mpfl4j83sx5khvvaddx7xs26ppkigmr2d1xpxgr7";
  };

  title-sequences-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "title-sequences";
    rev = "v${title-sequences-version}";
    sha256 = "1qdrm4q75bznmgdrpjdaiqvbf3q4vwbkkmls45izxvyg1djrpsdf";
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
    duktape
    fontconfig
    freetype
    icu
    jansson
    libGLU
    libiconv
    libpng
    libpthreadstubs
    libzip
    nlohmann_json
    openssl
    speexdsp
    zlib
  ];

  cmakeFlags = [
    "-DDOWNLOAD_OBJECTS=OFF"
    "-DDOWNLOAD_TITLE_SEQUENCES=OFF"
  ];

  postUnpack = ''
    cp -r ${objects-src}         $sourceRoot/data/object
    cp -r ${title-sequences-src} $sourceRoot/data/sequence
  '';

  preConfigure = ''
    # Verify that the correct version of each third party repository is used.

    grep -q '^set(OBJECTS_VERSION "${objects-version}")$' CMakeLists.txt \
      || (echo "OBJECTS_VERSION differs!"; exit 1)
    grep -q '^set(TITLE_SEQUENCE_VERSION "${title-sequences-version}")$' CMakeLists.txt \
      || (echo "TITLE_SEQUENCE_VERSION differs!"; exit 1)
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
