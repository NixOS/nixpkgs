{ fetchurl, stdenv, pkgconfig }:

stdenv.mkDerivation rec {
  name = "sparse-0.4.1";

  src = fetchurl {
    url = "mirror://kernel/software/devel/sparse/dist/${name}.tar.gz";
    sha256 = "18nkgqkqhfp4gdjhdy8xgwxvla5vjccg1kzyz5ngpjw35q0hp5fb";
  };

  preConfigure = ''
    sed -i "Makefile" \
        -e "s|^PREFIX *=.*$|PREFIX = $out|g"
  '';

  buildInputs = [ pkgconfig ];

  doCheck = true;

  meta = {
    description = "Sparse, a semantic parser for C";

    longDescription = ''
      Sparse, the semantic parser, provides a compiler frontend
      capable of parsing most of ANSI C as well as many GCC
      extensions, and a collection of sample compiler backends,
      including a static analyzer also called "sparse".  Sparse
      provides a set of annotations designed to convey semantic
      information about types, such as what address space pointers
      point to, or what locks a function acquires or releases.
    '';

    homepage = http://www.kernel.org/pub/software/devel/sparse/;

    # See http://www.opensource.org/licenses/osl.php .
    license = "Open Software License v1.1";
  };
}
