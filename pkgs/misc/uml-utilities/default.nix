{stdenv, fetchurl}:

derivation {
  name = "uml-utilities-20040114";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://unc.dl.sourceforge.net/sourceforge/user-mode-linux/uml_utilities_20040114.tar.bz2;
    md5 = "1fd5b791ef32c6a3ed4ae42c4a53a316";
  };
  inherit stdenv;
}
