{stdenv, fetchurl, kernel, xlibs, gtkLibs, zlib}:

let 

  versionNumber = "173.14.27";

in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}-${kernel.version}";
  
  builder = ./builder-legacy.sh;
  
  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}-pkg0.run";
        sha256 = "08l3zs7sb8n4vjm1vg3yy1pkj54dq7gfrjashlqwbznaa2cdwknb";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-pkg0.run";
        sha256 = "0pmg5whpk0rmzg8zb7qq2imva2hf346c4pvpz5sjir6346350blw";
      }
    else throw "nvidia-x11 does not support platform ${stdenv.system}";

  inherit versionNumber kernel;

  dontStrip = true;

  glPath = stdenv.lib.makeLibraryPath [xlibs.libXext xlibs.libX11 xlibs.libXrandr];

  cudaPath = stdenv.lib.makeLibraryPath [zlib stdenv.gcc.gcc];

  programPath = stdenv.lib.makeLibraryPath [
    gtkLibs.gtk gtkLibs.atk gtkLibs.pango gtkLibs.glib
    xlibs.libXv
  ];

  meta = {
    homepage = http://www.nvidia.com/object/unix.html;
    description = "X.org driver and kernel module for Legacy NVIDIA graphics cards";
    license = "unfree";
  };
}
