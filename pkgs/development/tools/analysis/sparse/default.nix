{ fetchurl, lib, stdenv, pkg-config, libxml2, llvm }:

stdenv.mkDerivation rec {
  name = "sparse-0.5.0";

  src = fetchurl {
    url = "mirror://kernel/software/devel/sparse/dist/${name}.tar.xz";
    sha256 = "1mc86jc5xdrdmv17nqj2cam2yqygnj6ar1iqkwsx2y37ij8wy7wj";
  };

  preConfigure = ''
    sed -i Makefile -e "s|^PREFIX=.*$|PREFIX=$out|g"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxml2 llvm ];
  doCheck = true;

  meta = {
    description = "Semantic parser for C";
    homepage    = "https://git.kernel.org/cgit/devel/sparse/sparse.git/";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
