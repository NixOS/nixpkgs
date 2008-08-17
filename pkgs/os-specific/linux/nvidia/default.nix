{stdenv, fetchurl, kernel, xlibs, gtkLibs, zlib}:

let 

  versionNumber = "173.14.12";

in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}-${kernel.version}";
  
  builder = ./builder.sh;
  
  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}-pkg1.run";
        sha256 = "0a4i4a7vk0j7z52d2pg92f8wnlabd4r6v19qxdrr8nhgm0imjh78";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-pkg2.run";
        sha256 = "1jblrvpa69z98g39sgadb3xbdsbzlvps4h9w73211l83sppqq84s"; # was 01hyyb5s7xc7108gy9cr7zkrfccfnpzqpipfygx9fikxyjb1vmig
      }
    else throw "nvidia-x11 does not support platform ${stdenv.system}";

  inherit versionNumber kernel;

  dontStrip = true;

  glPath = stdenv.lib.makeLibraryPath [xlibs.libXext xlibs.libX11];

  cudaPath = stdenv.lib.makeLibraryPath [zlib stdenv.gcc.gcc];

  programPath = stdenv.lib.makeLibraryPath [
    gtkLibs.gtk gtkLibs.atk gtkLibs.pango gtkLibs.glib xlibs.libXv
  ];

  meta = {
    homepage = http://www.nvidia.com/object/unix.html;
    description = "X.org driver and kernel module for NVIDIA graphics cards";
  };
}
