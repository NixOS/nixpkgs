{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, libuuid
, openal
, ogre
, ogre-caelum
, ois
, mygui
, curl
, mysocketw
, angelscript
, fmt
, rapidjson
, xorg
}:

stdenv.mkDerivation rec {
  version = "2021.04";
  pname = "rigsofrods";

  src = fetchFromGitHub {
    owner = "RigsOfRods";
    repo = "rigs-of-rods";
    rev = version;
    sha256 = "xV3GXVZhoRYVNFqOPCFKDnabhew2UuULQv4p8UKMAsU=";
    fetchSubmodules = true;
  };

  postPatch = ''
    sed -i '/set(PLUGINS_FOLDER "lib")/d' source/main/CMakeLists.txt
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/share/rigsofrods/RoR $out/bin
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    ogre
    ogre-caelum
    ois
    mygui
    fmt
    openal
    curl
    mysocketw
    angelscript
    rapidjson
    xorg.libX11
  ];

  cmakeFlags = [
    "-DBUILD_DEV_VERSION=off"
    "-DUSE_PACKAGE_MANAGER=off"
    "-DCMAKE_CXX_FLAGS=-Wno-error=format-security"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/share/rigsofrods"
    "-DOGRE_PLUGIN_DIR=${ogre}/lib/OGRE"
  ];

  meta = with lib; {
    description = "3D simulator game where you can drive, fly and sail various vehicles";
    homepage = "https://www.rigsofrods.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ raskin luc65r ];
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
