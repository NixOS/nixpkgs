{ stdenv
, fetchurl

, kernel
, coreutils
, xorg_server

#deps
,libXext, libX11

}:

let 

  versionNumber = "100.14.11";  #important ! to also update this if the sources are updated, this is used as follows: extensions/libglx.so.$versionNumber

in
stdenv.mkDerivation {
  name = "nvidiaDrivers-" + versionNumber;
  builder = ./builder.sh;
  
  nvidiasrc = fetchurl {										#we cannot use $src since this variable is also used in the nvidia sources
    #url = http://www.denbreejen.net/public/nixos/NVIDIA-Linux-x86-1.0-9755-pkg1.run;
    #sha256 = "1985373866b1dcae80f3da66dbbbd3c28ad76e75a620865be321ee870ad9d1ea";
    url = http://us.download.nvidia.com/XFree86/Linux-x86/100.14.11/NVIDIA-Linux-x86-100.14.11-pkg1.run;
    sha256 = "8665370e590328cc5bf3d13737739a80dacbfb6844436cab03c992e84bf16b0c";
  };
  inherit versionNumber;  

  kernelOutPath = kernel.outPath;
  xorgOutPath = xorg_server.outPath;

  buildInputs = [
    libXext libX11
  ];

  propagatedBuildInputs = [
    libX11 libXext
  ];

  NIX_LDFLAGS = "-rpath ${libX11}/lib -rpath ${libXext}/lib";
  LD_LIBRARY_PATH = "${libX11}/lib:${libXext}/lib/";
}
