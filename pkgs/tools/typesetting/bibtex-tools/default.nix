{stdenv, fetchurl, hevea, tetex, strategoxt, aterm, sdf}: 

stdenv.mkDerivation {
  name = "bibtex-tools-0.2pre13026";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/stratego/bibtex-tools-0.2pre13026/bibtex-tools-0.2pre13026.tar.gz;
    md5 = "2d8a5de7c53eb670307048eb3d14cdd6";
  };
  inherit aterm tetex hevea sdf strategoxt;
  buildInputs = [aterm sdf strategoxt hevea];
}
