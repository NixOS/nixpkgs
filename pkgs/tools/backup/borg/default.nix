{ stdenv, fetchurl, python3Packages, openssl, acl, lz4 }:

python3Packages.buildPythonPackage rec {
  name = "borgbackup-${version}";
  version = "0.27.0";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/b/borgbackup/borgbackup-${version}.tar.gz";
    sha256 = "04iizidag4fwy6kx1747d633s1amr81slgk743qsfbwixaxfjq9b";
  };

  propagatedBuildInputs = with python3Packages;
    [ cython msgpack openssl acl llfuse tox detox lz4 setuptools_scm ];

  preConfigure = ''
    export BORG_OPENSSL_PREFIX="${openssl}"
    export BORG_LZ4_PREFIX="${lz4}"
    # note: fix for this issue already upstream and probably in 0.27.1 (or whatever the next release is called)
    substituteInPlace setup.py --replace "possible_openssl_prefixes.insert(0, os.environ.get('BORG_LZ4_PREFIX'))" "possible_lz4_prefixes.insert(0, os.environ.get('BORG_LZ4_PREFIX'))"
  '';

  meta = with stdenv.lib; {
    description = "A deduplicating backup program (attic fork)";
    homepage = https://borgbackup.github.io/;
    license = licenses.bsd3;
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
  };
}
