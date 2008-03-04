{stdenv, fetchurl, kernel, xlibs, gtkLibs}:

let 

  versionNumber = "169.09";

in

stdenv.mkDerivation {
  name = "nvidiaDrivers-" + versionNumber;
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}-pkg1.run";
    sha256 = "1m3k2jyxi3xxpm6890y0d97jisnxiyyay59ss2r9abyvpkv3by8i";
  };

  #xenPatch = ./nvidia-2.6.24-xen.patch;

  inherit versionNumber kernel;

  dontStrip = true;

  libPath = [
    gtkLibs.gtk gtkLibs.atk gtkLibs.pango gtkLibs.glib 
    xlibs.libXext xlibs.libX11 xlibs.libXv
  ];
}
