{stdenv, fetchurl, kernel, xlibs, gtkLibs, zlib}:

let 

  versionNumber = "180.22";

in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}-${kernel.version}";
  
  builder = ./builder.sh;
  
  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}-pkg1.run";
        sha256 = "0cp6ii14pm8kzy1fy1qx2id2fp0lmb02akddid8wwdca7xpczqg7";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-pkg2.run";
        sha256 = "0yycsr8i5cc8bnqwvfrk0v9d7gxxv42zqdpz9ki8vxil7lvjfdxv";
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
