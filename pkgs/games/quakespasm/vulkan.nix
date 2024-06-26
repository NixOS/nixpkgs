{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  SDL2,
  gzip,
  libvorbis,
  libmad,
  vulkan-headers,
  vulkan-loader,
  moltenvk,
}:

stdenv.mkDerivation rec {
  pname = "vkquake";
  version = "1.22.3";

  src = fetchFromGitHub {
    owner = "Novum";
    repo = "vkQuake";
    rev = version;
    sha256 = "sha256-+8DU1QT3Lgqf1AIReVnXQ2Lq6R6eBb8VjdkJfAn/Rtc=";
  };

  sourceRoot = "${src.name}/Quake";

  nativeBuildInputs = [
    makeWrapper
    vulkan-headers
  ];

  buildInputs = [
    gzip
    SDL2
    libvorbis
    libmad
    vulkan-loader
  ] ++ lib.optional stdenv.isDarwin moltenvk;

  buildFlags = [ "DO_USERDIRS=1" ];

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  makeFlags = [ "prefix=$(out) bindir=$(out)/bin" ];

  env = lib.optionalAttrs stdenv.isDarwin {
    NIX_CFLAGS_COMPILE = "-Wno-error=unused-but-set-variable";
  };

  postFixup = ''
    wrapProgram $out/bin/vkquake \
      --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Vulkan Quake port based on QuakeSpasm";
    mainProgram = "vkquake";
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
    maintainers = with maintainers; [ ylh ];
  };
}
