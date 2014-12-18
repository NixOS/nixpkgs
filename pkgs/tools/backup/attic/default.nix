{stdenv, fetchurl, python3Packages, openssl, acl }:

python3Packages.buildPythonPackage rec {
  name = "attic-0.13";

  src = fetchurl {
      url = "https://github.com/jborg/attic/archive/0.14.tar.gz";
      sha256 = "929da4b2e900770cd31558e87074ade347b44937c944218549259ea64646f203";
      };

  buildInputs = with python3Packages;
    [ cython msgpack openssl acl ];

  preConfigure = ''
    export ATTIC_OPENSSL_PREFIX="${openssl}"
  '';

  meta = with stdenv.lib; {
    description = "A deduplication backup program";
    homepage = "https://attic-backup.org";
    license = stdenv.lib.licenses.bsd3;
 };
}
