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

  desktopItems = [
    (makeDesktopItem {
      name = "ecwolf";
      exec = "ecwolf";
      comment = "Enhanced Wolfenstein 3D port";
      desktopName = "Wolfenstein 3D";
      categories = [ "Game" ];
    })
  ];

  # Change the location where the ecwolf executable looks for the ecwolf.pk3
  # file.
  #
  # By default, it expects the PK3 file to reside in the same directory as the
  # executable, which is not desirable.
  # We will adjust the code so that it can be retrieved from the share/
  # directory.

  preConfigure = ''
    sed -i -e "s|ecwolf.pk3|$out/share/ecwolf/ecwolf.pk3|" src/version.h
  ''
  # Disable app bundle creation on Darwin. It fails, and it is not needed to run it from the Nix store
  + lib.optionalString stdenv.isDarwin ''
    sed -i -e "s|include(\''${CMAKE_CURRENT_SOURCE_DIR}/macosx/install.txt)||" src/CMakeLists.txt
  '';

  # Install the required PK3 file in the required data directory
  postInstall = ''
    mkdir -p $out/share/ecwolf
    cp ecwolf.pk3 $out/share/ecwolf
  '';

  meta = with lib; {
    description = "Enhanched SDL-based port of Wolfenstein 3D for various platforms";
    homepage = "https://maniacsvault.net/ecwolf/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sander ];
    platforms = platforms.all;
    # On Darwin, the linker fails to find a bunch of symbols.
    broken = stdenv.isDarwin;
  };
}
