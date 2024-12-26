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
  makeWrapper,
  meson,
  moltenvk,
  ninja,
  opusfile,
  pkg-config,
  stdenv,
  vulkan-headers,
  vulkan-loader,
}:

stdenv.mkDerivation rec {
  pname = "vkquake";
  version = "1.31.3";

  src = fetchFromGitHub {
    owner = "Novum";
    repo = "vkQuake";
    rev = version;
    sha256 = "sha256-VqTfcwt6/VTotD2Y7x7WiVwISRGOLfmMWh6EO5DSMX4=";
  };

  nativeBuildInputs = [
    makeWrapper
    glslang
    meson
    ninja
    pkg-config
  ];

  buildInputs =
    [
      SDL2
      flac
      gzip
      libmpg123
      libopus
      libvorbis
      opusfile
      vulkan-loader
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      moltenvk
      vulkan-headers
    ];

  buildFlags = [ "DO_USERDIRS=1" ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
      "-Wno-error=unused-but-set-variable"
      "-Wno-error=implicit-const-int-float-conversion"
    ];
  };

  installPhase = ''
    mkdir -p "$out/bin"
    cp vkquake "$out/bin"
  '';

  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    patchelf $out/bin/vkquake \
      --add-rpath ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = with lib; {
    description = "Vulkan Quake port based on QuakeSpasm";
    homepage = src.meta.homepage;
    longDescription = ''
      vkQuake is a Quake 1 port using Vulkan instead of OpenGL for rendering.
      It is based on the popular QuakeSpasm port and runs all mods compatible with it
      like Arcane Dimensions or In The Shadows. vkQuake also serves as a Vulkan demo
      application that shows basic usage of the API. For example it demonstrates render
      passes & sub passes, pipeline barriers & synchronization, compute shaders, push &
      specialization constants, CPU/GPU parallelism and memory pooling.
    '';

    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [
      PopeRigby
      ylh
    ];
    mainProgram = "vkquake";
  };
}
