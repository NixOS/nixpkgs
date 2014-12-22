{ stdenv, fetchurl, python3Packages, openssl, acl }:

python3Packages.buildPythonPackage rec {
  name = "attic-0.14";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/jborg/attic/archive/0.14.tar.gz";
    sha256 = "0zabh6cq7v1aml83y2r475vvy3mmmjbvkijk0bnyfx73z8hmsa3z";
  };

  propagatedBuildInputs = with python3Packages;
    [ cython msgpack openssl acl ];

  preConfigure = ''
    export ATTIC_OPENSSL_PREFIX="${openssl}"
  '';

  meta = with stdenv.lib; {
    description = "A deduplication backup program";
    homepage = "https://attic-backup.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.wscott ];
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
  };
}
