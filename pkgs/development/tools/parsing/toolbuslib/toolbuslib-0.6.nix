{stdenv, fetchurl, aterm}:

stdenv.mkDerivation {
  name = "toolbuslib-0.6";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/toolbuslib-0.6.tar.gz;
    md5 = "e117c574b428408ad172b1ad904ff430";
  };
  buildInputs = [aterm];
}

