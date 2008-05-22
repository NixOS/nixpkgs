{stdenv, fetchurl, kernel, xlibs, gtkLibs}:

let 

  versionNumber = "169.12";

in

stdenv.mkDerivation {
  name = "nvidiaDrivers-${versionNumber}-${kernel.version}";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}-pkg1.run";
    sha256 = "0bxxjp30bysqaviqjq05vmrhp17w3qn94iwwwj074qmi710zffyy";
  };

  #xenPatch = ./nvidia-2.6.24-xen.patch;

  inherit versionNumber kernel;

  dontStrip = true;

  libPath = [
    gtkLibs.gtk gtkLibs.atk gtkLibs.pango gtkLibs.glib 
    xlibs.libXext xlibs.libX11 xlibs.libXv
  ];
}
