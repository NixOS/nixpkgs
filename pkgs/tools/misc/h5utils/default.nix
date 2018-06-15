{ stdenv, fetchurl, lib
, hdf5, libpng, libjpeg
, hdf4 ? null
, libmatheval ? null
}:

stdenv.mkDerivation rec {
  version = "1.13.1";
  name = "h5utils-${version}";

  # fetchurl is used instead of fetchFromGitHub because the git repo version requires
  # additional tools to build compared to the tarball release; see the README for details.
  src = fetchurl {
    url = "https://github.com/stevengj/h5utils/releases/download/${version}/h5utils-${version}.tar.gz";
    sha256 = "0rbx3m8p5am8z5m0f3sryryfc41541hjpkixb1jkxakd9l36z9y5";
  };

  # libdf is an alternative name for libhdf (hdf4)
  preConfigure = lib.optionalString (hdf4 != null)
  ''
    substituteInPlace configure \
    --replace "-ldf" "-lhdf" \
  '';

  preBuild = lib.optionalString hdf5.mpiSupport "export CC=${hdf5.mpi}/bin/mpicc";

  buildInputs = with lib; [ hdf5 libjpeg libpng ] ++ optional hdf5.mpiSupport hdf5.mpi
    ++ optional (hdf4 != null) hdf4
    ++ optional (libmatheval != null) libmatheval;

  meta = with lib; {
    description = "A set of utilities for visualization and conversion of scientific data in the free, portable HDF5 format";
    homepage = https://github.com/stevengj/h5utils;
    license = with licenses; [ mit gpl2 ];
    maintainers = with maintainers; [ sfrijters ];
  };

}
