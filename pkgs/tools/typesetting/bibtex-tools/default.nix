{stdenv, fetchurl, hevea, tetex, strategoxt, aterm, sdf}: 

stdenv.mkDerivation {
  name = "bibtex-tools-0.2pre13026";
  src = fetchurl {
    url = http://tarballs.nixos.org/bibtex-tools-0.2pre13026.tar.gz;
    md5 = "2d8a5de7c53eb670307048eb3d14cdd6";
  };
  configureFlags = "
    --with-aterm=${aterm}
    --with-sdf=${sdf}
    --with-strategoxt=${strategoxt}
    --with-hevea=${hevea}
    --with-latex=${tetex}";
  buildInputs = [aterm sdf strategoxt hevea];
  meta.broken = true;
}
