{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  intel-gmmlib,
  intel-graphics-compiler,
  level-zero,
  libva,
}:

stdenv.mkDerivation rec {
  pname = "intel-compute-runtime";
  version = "24.17.29377.6";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "compute-runtime";
    rev = version;
    hash = "sha256-+bx6P1vZlgolHrINzkH4ukXT+hgAtH18DOX6vb9vPVs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    intel-gmmlib
    intel-graphics-compiler
    libva
    level-zero
  ];

  cmakeFlags = [
    "-DSKIP_UNIT_TESTS=1"
    "-DIGC_DIR=${intel-graphics-compiler}"
    "-DOCL_ICD_VENDORDIR=${placeholder "out"}/etc/OpenCL/vendors"
    # The install script assumes this path is relative to CMAKE_INSTALL_PREFIX
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  outputs = [
    "out"
    "drivers"
  ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  postInstall = ''
    # Avoid clash with intel-ocl
    mv $out/etc/OpenCL/vendors/intel.icd $out/etc/OpenCL/vendors/intel-neo.icd

    mkdir -p $drivers/lib
    mv -t $drivers/lib $out/lib/libze_intel*
  '';

  postFixup = ''
    patchelf --set-rpath ${
      lib.makeLibraryPath [
        intel-gmmlib
        intel-graphics-compiler
        libva
        stdenv.cc.cc.lib
      ]
    } \
      $out/lib/intel-opencl/libigdrcl.so
  '';

  meta = with lib; {
    description = "Intel Graphics Compute Runtime for OpenCL. Replaces Beignet for Gen8 (Broadwell) and beyond";
    mainProgram = "ocloc";
    homepage = "https://github.com/intel/compute-runtime";
    changelog = "https://github.com/intel/compute-runtime/releases/tag/${version}";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
