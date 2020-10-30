{ stdenv, fetchpatch, fetchFromGitHub, makeWrapper, SDL2, gzip, libvorbis, libmad, vulkan-headers, vulkan-loader }:

stdenv.mkDerivation rec {
  pname = "vkquake";
  version = "1.04.1";

  src = fetchFromGitHub {
    owner = "Novum";
    repo = "vkQuake";
    rev = version;
    sha256 = "1ry861pk3z02hy7i0yi3xwmd1zma802qzcnlm09w6pslayd9rwbf";
  };

  # patches and patchFlags can be deleted with the next release
  patches = [
    (fetchpatch {
      url = "https://github.com/Novum/vkQuake/commit/a869a22d9b51c68e57646fa20e4c40fc6db36760.patch";
      sha256 = "sha256-ea5lcXTTlJZnuOdF1W+GCYvVgj/gW10tDNyTgfl3Kfs=";
    })
  ];
  patchFlags = "-p2";

  sourceRoot = "source/Quake";

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
  ];

  buildFlags = [ "DO_USERDIRS=1" ];

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  makeFlags = [ "prefix=$(out) bindir=$(out)/bin" ];

  postFixup = ''
    wrapProgram $out/bin/vkquake \
      --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
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

    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
