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
<<<<<<< HEAD
  version = "23.22.26516.18";
=======
  version = "23.05.25593.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "intel";
    repo = "compute-runtime";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-SeNmCXqoUqTo1F3ia+4fAMHWJgdEz/PsNFEkrqM+0k4=";
=======
    sha256 = "sha256-AsJGcyVqRGz7OBWTlQeTS412iUzMAbIsA4w6CmEf1G8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

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

<<<<<<< HEAD
  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
