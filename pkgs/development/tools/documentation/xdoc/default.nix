{stdenv, fetchurl, strategoxt, aterm, sdf, subversion, graphviz}: 

stdenv.mkDerivation {
  name = "xdoc-0.1";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/xdoc-0.1.tar.gz;
    md5 = "6f601254013d5fe3d2fdbd33b827001a";
  };
  builder = ./builder.sh;
  inherit aterm strategoxt subversion graphviz ;
  inherit (sdf) sglr pgen ptsupport asflibrary;
  buildInputs = [aterm sdf.pgen strategoxt];
}
