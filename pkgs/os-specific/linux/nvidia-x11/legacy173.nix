{stdenv, fetchurl, kernel, xorg, zlib, gtk2, atk, pango, glib, gdk_pixbuf}:

let

  versionNumber = "173.14.39";

in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}-${kernel.version}";

  builder = ./builder-legacy173.sh;

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "https://download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}-pkg0.run";
        sha256 = "08xb7s7cxmj4zv4i3645kjhlhhwxiq6km9ixmsw3vv91f7rkb6d0";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "https://download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-pkg0.run";
        sha256 = "1p2ls0xj81l8v4n6dbjj3p5wlw1iyhgzyvqcv4h5fdxhhs2cb3md";
      }
    else throw "nvidia-x11 does not support platform ${stdenv.system}";

  kernel = kernel.dev;

  hardeningDisable = [ "pic" "format" ];

  inherit versionNumber;

  dontStrip = true;

  glPath = stdenv.lib.makeLibraryPath [xorg.libXext xorg.libX11 xorg.libXrandr];

  cudaPath = stdenv.lib.makeLibraryPath [zlib stdenv.cc.cc];

  programPath = stdenv.lib.makeLibraryPath [ gtk2 atk pango glib gdk_pixbuf xorg.libXv ];

  passthru = {
    settings = null;
    persistenced = null;
    useGLVND = false;
    useProfiles = false;
  };

  meta = {
    homepage = http://www.nvidia.com/object/unix.html;
    description = "X.org driver and kernel module for Legacy NVIDIA graphics cards";
    license = stdenv.lib.licenses.unfree;
  };
}
