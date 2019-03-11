{ stdenv, SDL2, fetchFromGitHub, makeWrapper, gzip, libvorbis, libmad, vulkan-headers, vulkan-loader }:

stdenv.mkDerivation rec {
  name = "vkquake-${version}";
  majorVersion = "1.01";
  version = "${majorVersion}.0";

  src = fetchFromGitHub {
    owner = "Novum";
    repo = "vkQuake";
    rev = version;
    sha256 = "1iwin8j5kbyrknbkhjgpy8nmm7pxqzr0daa9gn7p38qhg2mh0a39";
  };

  sourceRoot = "source/Quake";

  nativeBuildInputs = [
    makeWrapper vulkan-headers
  ];

  buildInputs = [
    gzip SDL2 libvorbis libmad vulkan-loader
  ];

  buildFlags = [ "DO_USERDIRS=1" ];

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  makeFlags = [ "prefix=$(out) bindir=$(out)/bin" ];

  postFixup = ''
    wrapProgram $out/bin/vkquake --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
  '';

  enableParallelBuilding = true;

  meta = {
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

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.gnidorah ];
  };
}
