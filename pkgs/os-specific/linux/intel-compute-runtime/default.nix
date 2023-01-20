{ lib
, stdenv
, fetchFromGitHub
, patchelf
, cmake
, pkg-config
, intel-gmmlib
, intel-graphics-compiler
, level-zero
, libva
}:

stdenv.mkDerivation rec {
  pname = "intel-compute-runtime";
  version = "22.43.24595.35";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "compute-runtime";
    rev = version;
    sha256 = "sha256-CWiWkv3CmHhXAk2M92voeQ06ximSOnT9hgIA4rIxWmM=";
  };

  patches = [ ./fix_typo.patch ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ intel-gmmlib intel-graphics-compiler libva level-zero ];

  cmakeFlags = [
    "-DSKIP_UNIT_TESTS=1"
    "-DIGC_DIR=${intel-graphics-compiler}"
    "-DOCL_ICD_VENDORDIR=${placeholder "out"}/etc/OpenCL/vendors"
    # The install script assumes this path is relative to CMAKE_INSTALL_PREFIX
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  outputs = [ "out" "drivers" ];

  postInstall = ''
    # Avoid clash with intel-ocl
    mv $out/etc/OpenCL/vendors/intel.icd $out/etc/OpenCL/vendors/intel-neo.icd

    mkdir -p $drivers/lib
    mv -t $drivers/lib $out/lib/libze_intel*
  '';

  postFixup = ''
    patchelf --set-rpath ${lib.makeLibraryPath [ intel-gmmlib intel-graphics-compiler libva stdenv.cc.cc.lib ]} \
      $out/lib/intel-opencl/libigdrcl.so
  '';

  meta = with lib; {
    homepage = "https://github.com/intel/compute-runtime";
    description = "Intel Graphics Compute Runtime for OpenCL. Replaces Beignet for Gen8 (Broadwell) and beyond";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
