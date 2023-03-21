{ lib
, stdenv
, fetchFromGitHub
, cmake
, makeWrapper
, pkg-config
, unzip
, ogre
, openal
, ois
, mygui
, fmt
, rapidjson
, mysocketw
, angelscript
, curl
, ogrepaged
, libX11
, darwin
}:

stdenv.mkDerivation rec {
  pname = "rigsofrods";
  version = "2022.12";

  src = fetchFromGitHub {
    owner = "RigsOfRods";
    repo = "rigs-of-rods";
    rev = version;
    hash = "sha256-o/5MNqkzxuSvzZZjLy14OTGTaSt3Gz74+V4TInZVWAo=";
    fetchSubmodules = true;
  };

  postPatch = ''
    sed -i '/set(PLUGINS_FOLDER "lib")/d' source/main/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    unzip
  ];

  buildInputs = [
    ogre
    openal
    ois
    mygui
    fmt
    rapidjson
    mysocketw
    angelscript
    curl
    ogrepaged
    libX11
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.OpenAL
  ];

  cmakeFlags = [
    "-DBUILD_DEV_VERSION=off"
    "-DUSE_PACKAGE_MANAGER=off"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/share/rigsofrods"
    "-DOGRE_PLUGIN_DIR=${ogre}/lib/OGRE"
  ];

  NIX_CFLAGS_COMPILE = "-Wno-format-security";

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/share/rigsofrods/RoR $out/bin/RoR
  '';

  meta = with lib; {
    description = "3D simulator game where you can drive, fly and sail various vehicles";
    homepage = "https://www.rigsofrods.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
