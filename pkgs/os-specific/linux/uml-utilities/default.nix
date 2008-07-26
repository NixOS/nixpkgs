{lib, stdenv, fetchurl, kernelHeaders , readline, tunctl ? false, mconsole ? false}:

stdenv.mkDerivation {
  inherit tunctl mconsole;
  buildInputs = lib.optional tunctl kernelHeaders
            ++ lib.optional mconsole readline;
  name = "uml-utilities-20040114";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/uml_utilities_20040114.tar.bz2;
    md5 = "1fd5b791ef32c6a3ed4ae42c4a53a316";
  };
}
