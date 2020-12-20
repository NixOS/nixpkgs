{ stdenv
, fetchFromGitHub
, patchelf
, cmake
, pkgconfig

, intel-gmmlib
, intel-graphics-compiler
, libva
}:

stdenv.mkDerivation rec {
  pname = "intel-compute-runtime";
  version = "20.34.17727";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "compute-runtime";
    rev = version;
    sha256 = "19scbbr6jf3yp2v7z8xyzzm01g44jym7xfkf1dz64d5nhvjw6ig5";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ intel-gmmlib intel-graphics-compiler libva ];

  cmakeFlags = [
    "-DSKIP_UNIT_TESTS=1"

    "-DIGC_DIR=${intel-graphics-compiler}"
    "-DOCL_ICD_VENDORDIR=${placeholder "out"}/etc/OpenCL/vendors"

    # The install script assumes this path is relative to CMAKE_INSTALL_PREFIX
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  postInstall = ''
    # Avoid clash with intel-ocl
    mv $out/etc/OpenCL/vendors/intel.icd $out/etc/OpenCL/vendors/intel-neo.icd
  '';

  postFixup = ''
    patchelf --set-rpath ${stdenv.lib.makeLibraryPath [ intel-gmmlib intel-graphics-compiler libva stdenv.cc.cc.lib ]} \
      $out/lib/intel-opencl/libigdrcl.so
  '';

  meta = with stdenv.lib; {
    homepage    = "https://github.com/intel/compute-runtime";
    description = "Intel Graphics Compute Runtime for OpenCL. Replaces Beignet for Gen8 (Broadwell) and beyond";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ gloaming ];
  };
}
