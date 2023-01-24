{ lib, stdenv, fetchFromGitHub, cmake, zlib, netcdf, nifticlib, hdf5 }:

stdenv.mkDerivation rec {
  pname   = "libminc";
  version = "2.4.05";

  owner = "BIC-MNI";

  src = fetchFromGitHub {
    inherit owner;
    repo   = pname;
    rev    = "aa08255f0856e70fb001c5f9ee1f4e5a8c12d47d";  # new release, but no git tag
    sha256 = "XMTO6/HkyrrQ0s5DzJLCmmWheye2DGMnpDbcGdP6J+A=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib nifticlib ];
  propagatedBuildInputs = [ netcdf hdf5 ];

  cmakeFlags = [
    "-DLIBMINC_MINC1_SUPPORT=ON"
    "-DLIBMINC_BUILD_SHARED_LIBS=ON"
    "-DLIBMINC_USE_NIFTI=ON"
    "-DLIBMINC_USE_SYSTEM_NIFTI=ON"
  ];

  doCheck = !stdenv.isDarwin;
    # -j1: see https://github.com/BIC-MNI/libminc/issues/110
  checkPhase = ''
    ctest -j1 --output-on-failure
  '';

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/libminc";
    description = "Medical imaging library based on HDF5";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
  };
}
