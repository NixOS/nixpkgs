{ lib, stdenv, fetchurl, cmake
, libGL, libGLU, libXv, libXtst, libXi, libjpeg_turbo, fltk
, xorg
, opencl-headers, opencl-clhpp, ocl-icd
}:

stdenv.mkDerivation rec {
  pname = "virtualgl-lib";
  version = "2.6.5";

  src = fetchurl {
    url = "mirror://sourceforge/virtualgl/VirtualGL-${version}.tar.gz";
    sha256 = "1giin3jmcs6y616bb44bpz30frsmj9f8pz2vg7jvb9vcfc9456rr";
  };

  cmakeFlags = [ "-DVGL_SYSTEMFLTK=1" "-DTJPEG_LIBRARY=${libjpeg_turbo.out}/lib/libturbojpeg.so" ];

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libjpeg_turbo libGL libGLU fltk
    libXv libXtst libXi xorg.xcbutilkeysyms
    opencl-headers opencl-clhpp ocl-icd
  ];

  fixupPhase = ''
    substituteInPlace $out/bin/vglrun \
      --replace "LD_PRELOAD=libvglfaker" "LD_PRELOAD=$out/lib/libvglfaker" \
      --replace "LD_PRELOAD=libdlfaker" "LD_PRELOAD=$out/lib/libdlfaker" \
      --replace "LD_PRELOAD=libgefaker" "LD_PRELOAD=$out/lib/libgefaker"
  '';

  meta = with lib; {
    homepage = "http://www.virtualgl.org/";
    description = "X11 GL rendering in a remote computer with full 3D hw acceleration";
    license = licenses.wxWindows;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
