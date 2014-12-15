{stdenv, fetchurl, python3Packages, openssl, acl }:

python3Packages.buildPythonPackage rec {
  name = "attic-0.13";

  src = fetchurl {
      url = "https://github.com/jborg/attic/archive/0.13.tar.gz";
      sha256 = "da1c4c0759b541e72f6928341c863b406448351769113165d86d8393a5db98a3";
      };

  buildInputs = with python3Packages;
    [ cython msgpack openssl acl ];

  meta = with stdenv.lib; {
    description = "A deduplication backup program";
    homepage = "https://attic-backup.org";
    license = stdenv.lib.licenses.bsd3;
 };
}
