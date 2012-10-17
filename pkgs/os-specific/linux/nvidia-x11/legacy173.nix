{stdenv, fetchurl, kernel, xlibs, zlib, gtk, atk, pango, glib, gdk_pixbuf}:

let 

  versionNumber = "173.14.36";

in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}-${kernel.version}";
  
  builder = ./builder-legacy.sh;
  
  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}-pkg0.run";
        sha256 = "19wnikms9wradf1kmaywnp7hykrdm4xqz2ka7az66s3ma096y95c";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-pkg0.run";
        sha256 = "1xf1w6qvqw0a3vd807hp3cgqmzm1wkpz2by52p0qgpjqld421k2s";
      }
    else throw "nvidia-x11 does not support platform ${stdenv.system}";

  inherit versionNumber kernel;

  dontStrip = true;

  glPath = stdenv.lib.makeLibraryPath [xlibs.libXext xlibs.libX11 xlibs.libXrandr];

  cudaPath = stdenv.lib.makeLibraryPath [zlib stdenv.gcc.gcc];

  programPath = stdenv.lib.makeLibraryPath [ gtk atk pango glib gdk_pixbuf xlibs.libXv ];

  meta = {
    homepage = http://www.nvidia.com/object/unix.html;
    description = "X.org driver and kernel module for Legacy NVIDIA graphics cards";
    license = "unfree";
  };
}
