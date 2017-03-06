{ stdenv, fetchurl, autoconf, libelf, libiberty, gfortran, zlib, binutils }:

stdenv.mkDerivation rec {
  version = "1.0.6";
  name = "EZTrace-${version}";

  src = fetchurl {
    url = "http://gforge.inria.fr/frs/download.php/file/34082/eztrace-${version}.tar.gz";
    sha256 = "06q5y9qmdn1h0wjmy28z6gwswskmph49j7simfqcqwv05gvd9svr";
  };

  # Goes past the rpl_malloc linking failure
  preConfigure = ''
    export ac_cv_func_malloc_0_nonnull=yes
  '';

  buildInputs = [ autoconf libelf libiberty gfortran zlib binutils ];

  meta = {
    description = "Tool that aims at generating automatically execution trace from HPC programs";
    license = stdenv.lib.licenses.cecill-b;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
