{stdenv, fetchurl, kernel, xlibs, gtkLibs, zlib}:

let 

  versionNumber = "96.43.14";

in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}-${kernel.version}";
  
  builder = ./builder.sh;
  
  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}-pkg0.run";
        sha256 = "0v93ijdpgh3vpbhrikzync6pws5i471ykqbpp7gahv7hf51z61kr";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-pkg0.run";
        sha256 = "0m5gj8wb1w5rwh2qi5bvkxlwy9igwfjifjyyqkd17x0v0rw6iyhr";
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
