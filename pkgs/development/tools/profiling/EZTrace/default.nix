{ stdenv
, fetchurl, autoconf, gfortran
, libelf, libiberty, zlib, libbfd, libopcodes
, buildPackages
}:

stdenv.mkDerivation rec {
  version = "1.1-7";
  pname = "EZTrace";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/37155/eztrace-${version}.tar.gz";
    sha256 = "0cr2d4fdv4ljvag55dsz3rpha1jan2gc3jhr06ycyk43450pl58p";
  };

  # Goes past the rpl_malloc linking failure; fixes silent file breakage
  preConfigure = ''
    export ac_cv_func_malloc_0_nonnull=yes
    substituteInPlace ./configure \
      --replace "/usr/bin/file" "${buildPackages.file}/bin/file"
  '';

  nativeBuildInputs = [ autoconf gfortran ];
  buildInputs = [ libelf libiberty zlib libbfd libopcodes ];

  meta = {
    description = "Tool that aims at generating automatically execution trace from HPC programs";
    license = stdenv.lib.licenses.cecill-b;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}
