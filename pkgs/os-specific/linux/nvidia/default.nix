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

  # Fix for compiling on Linux >= 2.6.24.
  patch = fetchurl {
    url = "http://www.nvnews.net/vbulletin/attachment.php?s=41498f047cfc027419df58a2559e9a7f&attachmentid=30771&d=1205875946";
    sha256 = "17bb9yzkys1fsvf0mri3kpj1zvvqwvdcaszcl8ax9jfkxbd47m9n";
    name = "nvidia-2.5.24.patch";
  };

  #xenPatch = ./nvidia-2.6.24-xen.patch;

  inherit versionNumber kernel;

  dontStrip = true;

  libPath = [
    gtkLibs.gtk gtkLibs.atk gtkLibs.pango gtkLibs.glib 
    xlibs.libXext xlibs.libX11 xlibs.libXv
  ];
}
