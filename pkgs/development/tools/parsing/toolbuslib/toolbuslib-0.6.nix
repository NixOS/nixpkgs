{stdenv, fetchurl, aterm}:

stdenv.mkDerivation {
  name = "toolbuslib-0.6";
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/toolbuslib/toolbuslib-0.6.tar.gz;
    md5 = "e117c574b428408ad172b1ad904ff430";
  };
  buildInputs = [aterm];
}

