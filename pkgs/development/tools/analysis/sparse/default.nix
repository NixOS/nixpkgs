{ fetchurl, stdenv, pkgconfig }:

stdenv.mkDerivation rec {
  name = "sparse-0.4.4";

  src = fetchurl {
    url = "mirror://kernel/software/devel/sparse/dist/${name}.tar.gz";
    sha256 = "5ad02110130fd8f8d82f2b030de5f2db6f924fd805593a5b8be8072a620414c6";
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
