{ stdenv, fetchurl, python3Packages, openssl, acl, lz4 }:

python3Packages.buildPythonPackage rec {
  name = "borgbackup-${version}";
  version = "0.30.0";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/b/borgbackup/borgbackup-${version}.tar.gz";
    sha256 = "0n78c982kdfqbyi9jawcvzgdik4l36c2s7rpzkfr1ka6506k2rx4";
  };

  propagatedBuildInputs = with python3Packages;
    [ cython msgpack openssl acl llfuse tox detox lz4 setuptools_scm ];

  preConfigure = ''
    export BORG_OPENSSL_PREFIX="${openssl}"
    export BORG_LZ4_PREFIX="${lz4}"
  '';

  meta = with stdenv.lib; {
    description = "A deduplicating backup program (attic fork)";
    homepage = https://borgbackup.github.io/;
    license = licenses.bsd3;
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
    maintainers = with maintainers; [ nckx ];
  };
}
