{
  SDL2,
  fetchFromGitHub,
  flac,
  glslang,
  gzip,
  lib,
  libmpg123,
  libopus,
  libvorbis,
  libX11,
  makeWrapper,
  meson,
  moltenvk,
  ninja,
  opusfile,
  pkg-config,
  stdenv,
  vulkan-headers,
  vulkan-loader,
  copyDesktopItems,
  makeDesktopItem,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vkquake";
  version = "1.32.3.1";

  src = fetchFromGitHub {
    owner = "Novum";
    repo = "vkQuake";
    tag = finalAttrs.version;
    hash = "sha256-Hsj6LgxlEICI3MMDMCE1KvslYrsYfQPhShpP5kzLCTI=";
  };

  nativeBuildInputs = [
    makeWrapper
    glslang
    meson
    ninja
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    SDL2
    flac
    gzip
    libmpg123
    libopus
    libvorbis
    libX11
    opusfile
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    moltenvk
    vulkan-headers
  ];

  mesonFlags = [ "-Ddo_userdirs=enabled" ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
      "-Wno-error=unused-but-set-variable"
      "-Wno-error=implicit-const-int-float-conversion"
    ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp vkquake "$out/bin"

    install -D ../Misc/vkQuake_256.png "$out/share/icons/hicolor/256x256/apps/vkquake.png"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      exec = finalAttrs.meta.mainProgram;
      name = "vkquake";
      icon = "vkquake";
      comment = finalAttrs.meta.description;
      desktopName = "vkQuake";
      categories = [ "Game" ];
    })
  ];

  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    patchelf $out/bin/vkquake \
      --add-rpath ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = {
    description = "Vulkan Quake port based on QuakeSpasm";
    homepage = "https://github.com/Novum/vkQuake";
    changelog = "https://github.com/Novum/vkQuake/releases";
    longDescription = ''
      vkQuake is a Quake 1 port using Vulkan instead of OpenGL for rendering.
      It is based on the popular QuakeSpasm port and runs all mods compatible with it
      like Arcane Dimensions or In The Shadows. vkQuake also serves as a Vulkan demo
      application that shows basic usage of the API. For example it demonstrates render
      passes & sub passes, pipeline barriers & synchronization, compute shaders, push &
      specialization constants, CPU/GPU parallelism and memory pooling.
    '';

    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      PopeRigby
      ylh
    ];
    mainProgram = "vkquake";
    license = lib.licenses.gpl2Plus;
  };
})
