{ stdenv
, cmake
, lsb-release
, ninja
, lib
, fetchFromGitHub
, fetchurl
, copyDesktopItems
, makeDesktopItem
, python3
, libX11
, libXrandr
, libXinerama
, libXcursor
, libXi
, libXext
, glew
, boost
, SDL2
, SDL2_net
, pkg-config
, libpulseaudio
, libpng
, imagemagick
, gnome
, makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shipwright";
  version = "8.0.5";

  src = fetchFromGitHub {
    owner = "harbourmasters";
    repo = "shipwright";
    rev = finalAttrs.version;
    hash = "sha256-o2VwOF46Iq4pwpumOau3bDXJ/CArx6NWBi00s3E4PnE=";
    fetchSubmodules = true;
  };

  # This would get fetched at build time otherwise, see:
  # https://github.com/HarbourMasters/Shipwright/blob/e46c60a7a1396374e23f7a1f7122ddf9efcadff7/soh/CMakeLists.txt#L736
  gamecontrollerdb = fetchurl {
    name = "gamecontrollerdb.txt";
    url = "https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/b7933e43ca2f8d26d8b668ea8ea52b736221af1e/gamecontrollerdb.txt";
    hash = "sha256-XIuS9BkWkM9d+SgT1OYTfWtcmzqSUDbMrMLoVnPgidE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    lsb-release
    python3
    imagemagick
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    boost
    libX11
    libXrandr
    libXinerama
    libXcursor
    libXi
    libXext
    glew
    SDL2
    SDL2_net
    libpulseaudio
    libpng
    gnome.zenity
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/lib"
    (lib.cmakeBool "NON_PORTABLE" true)
  ];

  dontAddPrefix = true;

  # Linking fails without this
  hardeningDisable = [ "format" ];

  postBuild = ''
    cp ${finalAttrs.gamecontrollerdb} ${finalAttrs.gamecontrollerdb.name}
    pushd ../OTRExporter
    python3 ./extract_assets.py -z ../build/ZAPD/ZAPD.out --norom --xml-root ../soh/assets/xml --custom-assets-path ../soh/assets/custom --custom-otr-file soh.otr --port-ver ${finalAttrs.version}
    popd
  '';

  preInstall = ''
    # Cmake likes it here for its install paths
    cp ../OTRExporter/soh.otr ..
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/lib/soh.elf $out/bin/soh
    install -Dm644 ../soh/macosx/sohIcon.png $out/share/pixmaps/soh.png
  '';

  fixupPhase = ''
    wrapProgram $out/lib/soh.elf --prefix PATH ":" ${lib.makeBinPath [ gnome.zenity ]}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "soh";
      icon = "soh";
      exec = "soh";
      comment = finalAttrs.meta.description;
      genericName = "Ship of Harkinian";
      desktopName = "soh";
      categories = [ "Game" ];
    })
  ];

  meta = {
    homepage = "https://github.com/HarbourMasters/Shipwright";
    description = "A PC port of Ocarina of Time with modern controls, widescreen, high-resolution, and more";
    mainProgram = "soh";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ivar j0lol ];
    license = with lib.licenses; [
      # OTRExporter, OTRGui, ZAPDTR, libultraship
      mit
      # Ship of Harkinian itself
      unfree
    ];
  };
})
