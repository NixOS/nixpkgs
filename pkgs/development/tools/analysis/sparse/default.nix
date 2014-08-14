{ fetchurl, stdenv, pkgconfig, libxml2, llvm }:

stdenv.mkDerivation rec {
  name = "sparse-0.5.0";

  src = fetchurl {
    url = "mirror://kernel/software/devel/sparse/dist/${name}.tar.xz";
    sha256 = "1mc86jc5xdrdmv17nqj2cam2yqygnj6ar1iqkwsx2y37ij8wy7wj";
  };

  preConfigure = ''
    sed -i Makefile -e "s|^PREFIX=.*$|PREFIX=$out|g"
  '';

  buildInputs = [ pkgconfig libxml2 llvm ];
  doCheck = true;

  meta = {
    description = "Sparse, a semantic parser for C";
    homepage    = "https://git.kernel.org/cgit/devel/sparse/sparse.git/";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
