{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libGL,
  libGLU,
  libXv,
  libXtst,
  libXi,
  libjpeg_turbo,
  fltk,
  xorg,
  opencl-headers,
  opencl-clhpp,
  ocl-icd,
}:

stdenv.mkDerivation rec {
  pname = "virtualgl-lib";
  version = "3.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/virtualgl/VirtualGL-${version}.tar.gz";
    sha256 = "sha256-OIEbwAQ71yOuHIzM+iaK7QkUJrKg6sXpGuFQOUPjM2w=";
  };

  postPatch = ''
    # the unit tests take significant hacks to build and can't run anyway due to the lack
    # of a 3D X server in the build sandbox. so we just chop out their build instructions.
    head -n $(grep -n 'UNIT TESTS' server/CMakeLists.txt | cut -d : -f 1) server/CMakeLists.txt > server/CMakeLists2.txt
    mv server/CMakeLists2.txt server/CMakeLists.txt
  '';

  cmakeFlags = [
    "-DVGL_SYSTEMFLTK=1"
    "-DTJPEG_LIBRARY=${libjpeg_turbo.out}/lib/libturbojpeg.so"
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libjpeg_turbo
    libGL
    libGLU
    fltk
    libXv
    libXtst
    libXi
    xorg.xcbutilkeysyms
    opencl-headers
    opencl-clhpp
    ocl-icd
  ];

  fixupPhase = ''
    substituteInPlace $out/bin/vglrun \
      --replace "LD_PRELOAD=libvglfaker" "LD_PRELOAD=$out/lib/libvglfaker" \
      --replace "LD_PRELOAD=libdlfaker" "LD_PRELOAD=$out/lib/libdlfaker" \
      --replace "LD_PRELOAD=libgefaker" "LD_PRELOAD=$out/lib/libgefaker"
  '';

  meta = with lib; {
    homepage = "https://www.virtualgl.org/";
    description = "X11 GL rendering in a remote computer with full 3D hw acceleration";
    license = with licenses; [
      lgpl2Plus
      wxWindowsException31
    ];
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
