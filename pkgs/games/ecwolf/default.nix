{ stdenv
, lib
, fetchFromBitbucket
, makeDesktopItem
, copyDesktopItems
, cmake
, pkg-config
, zlib
, bzip2
, libjpeg
, SDL2
, SDL2_net
, SDL2_mixer
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "ecwolf";
  version = "1.4.0";

  src = fetchFromBitbucket {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "n1G1zvfE1l42fbJ7ZaMdV0QXn45PjMpaaZTDQAOBtYk=";
  };

  nativeBuildInputs = [ cmake copyDesktopItems pkg-config ];
  buildInputs = [ zlib bzip2 libjpeg SDL2 SDL2_net SDL2_mixer gtk3 ];

  # Disable app bundle creation on Darwin. It fails, and it is not needed to run it from the Nix store
  preConfigure = lib.optionalString stdenv.isDarwin ''
    sed -i -e "s|include(\''${CMAKE_CURRENT_SOURCE_DIR}/macosx/install.txt)||" src/CMakeLists.txt
  '';

  # ECWolf installs its binary to the games/ directory, but Nix only adds bin/
  # directories to the PATH.
  postInstall = ''
    mv "$out/games" "$out/bin"
  '';

  meta = with lib; {
    description = "Enhanched SDL-based port of Wolfenstein 3D for various platforms";
    homepage = "https://maniacsvault.net/ecwolf/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jayman2000 sander ];
    platforms = platforms.all;
    # On Darwin, the linker fails to find a bunch of symbols.
    broken = stdenv.isDarwin;
  };
}
