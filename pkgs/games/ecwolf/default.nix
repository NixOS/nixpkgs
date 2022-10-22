{ stdenv, lib, fetchurl, makeDesktopItem, copyDesktopItems, cmake, pkg-config, zlib, bzip2, libjpeg, SDL, SDL_mixer, gtk2 }:

stdenv.mkDerivation rec {
  pname = "ecwolf";
  version = "1.3.3";

  src = fetchurl {
    url = "https://maniacsvault.net/ecwolf/files/ecwolf/1.x/${pname}-${version}-src.tar.xz";
    sha256 = "1sbdv672dz47la5a5qwmdi1v258k9kc5dkx7cdj2b6gk8nbm2srl";
  };

  nativeBuildInputs = [ cmake copyDesktopItems pkg-config ];
  buildInputs = [ zlib bzip2 libjpeg SDL SDL_mixer gtk2 ];

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
  };
}
