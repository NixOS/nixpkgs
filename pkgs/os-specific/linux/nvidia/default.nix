{stdenv, fetchurl, kernel, xlibs, gtkLibs}:

let 

  versionNumber = "169.07";

in

stdenv.mkDerivation {
  name = "nvidiaDrivers-" + versionNumber;
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}-pkg1.run";
    sha256 = "1q4sbwcf24rvx72sj19pvhsmg5n8v2rfzsxf56mfxjbiy2jhjbaa";
  };

  #xenPatch = ./nvidia-2.6.24-xen.patch;

  inherit versionNumber kernel;

  libPath = [
    gtkLibs.gtk gtkLibs.atk gtkLibs.pango gtkLibs.glib 
    xlibs.libXext xlibs.libX11 xlibs.libXv
  ];
}
