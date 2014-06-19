{stdenv, fetchurl, kernel, xlibs, zlib, gtk, atk, pango, glib, gdk_pixbuf}:

let 

  versionNumber = "173.14.39";

in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}-${kernel.version}";
  
  builder = ./builder-legacy.sh;
  
  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}-pkg0.run";
        sha256 = "08xb7s7cxmj4zv4i3645kjhlhhwxiq6km9ixmsw3vv91f7rkb6d0";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-pkg0.run";
        sha256 = "1p2ls0xj81l8v4n6dbjj3p5wlw1iyhgzyvqcv4h5fdxhhs2cb3md";
      }
    else throw "nvidia-x11 does not support platform ${stdenv.system}";

  kernel = kernel.dev;

  inherit versionNumber;

  dontStrip = true;

  glPath = stdenv.lib.makeLibraryPath [xlibs.libXext xlibs.libX11 xlibs.libXrandr];

  cudaPath = stdenv.lib.makeLibraryPath [zlib stdenv.gcc.gcc];

  programPath = stdenv.lib.makeLibraryPath [ gtk atk pango glib gdk_pixbuf xlibs.libXv ];

  meta = {
    homepage = http://www.nvidia.com/object/unix.html;
    description = "X.org driver and kernel module for Legacy NVIDIA graphics cards";
    license = stdenv.lib.licenses.unfree;
  };
}
