{stdenv, fetchurl, kernel, xlibs, gtkLibs}:

let 

  versionNumber = "173.14.05";

in

stdenv.mkDerivation {
  name = "nvidiaDrivers-${versionNumber}-${kernel.version}";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}-pkg1.run";
    sha256 = "14r3zddrppd0zxq76dd08dlj4qqncr7fj9cnrny4f0b5d0qgrd3f";
  };

  #xenPatch = ./nvidia-2.6.24-xen.patch;

  inherit versionNumber kernel;

  dontStrip = true;

  libPath = [
    gtkLibs.gtk gtkLibs.atk gtkLibs.pango gtkLibs.glib 
    xlibs.libXext xlibs.libX11 xlibs.libXv
  ];
}
