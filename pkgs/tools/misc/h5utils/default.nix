{ stdenv, fetchurl, lib
, hdf5, libpng, libjpeg
, hdf4 ? null
, libmatheval ? null
}:

stdenv.mkDerivation rec {
  version = "1.13.2";
  pname = "h5utils";

  # fetchurl is used instead of fetchFromGitHub because the git repo version requires
  # additional tools to build compared to the tarball release; see the README for details.
  src = fetchurl {
    url = "https://github.com/stevengj/h5utils/releases/download/${version}/h5utils-${version}.tar.gz";
    sha256 = "sha256-7qeFWoI1+st8RU5hEDCY5VZY2g3fS23luCqZLl8CQ1E=";
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
    homepage = "https://github.com/stevengj/h5utils";
    changelog = "https://github.com/NanoComp/h5utils/releases/tag/${version}";
    license = with licenses; [ mit gpl2 ];
    maintainers = with maintainers; [ sfrijters ];
  };

}
