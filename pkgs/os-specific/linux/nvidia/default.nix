{ stdenv
, fetchurl

, kernel
, coreutils
, xorg_server

#deps
,libXext, libX11

}:

stdenv.mkDerivation {
  name = "nvidiaDrivers";
  builder = ./builder.sh;
  
  nvidiasrc = fetchurl {										#we cannot use $src since this variable is also used in the nvidia sources
    url = http://www.denbreejen.net/public/nixos/NVIDIA-Linux-x86-1.0-9755-pkg1.run;
    sha256 = "1985373866b1dcae80f3da66dbbbd3c28ad76e75a620865be321ee870ad9d1ea";
  };

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
