{ stdenv, fetchzip, python3Packages, openssl, acl, fetchurl, pkgconfig, fuse, attr, which }:

let

  # Old version needed for attic (backup program) due to breaking change in
  # llfuse >= 0.42.
  llfuse-0-41 = python3Packages.buildPythonPackage rec {
    name = "llfuse-0.41.1";
    src = fetchurl {
      url = "mirror://pypi/l/llfuse/${name}.tar.bz2";
      sha256 = "1imlqw9b73086y97izr036f58pgc5akv4ihc2rrf8j5h75jbrlaa";
    };
    buildInputs = with python3Packages; [ pytest pkgconfig fuse attr which ];
    propagatedBuildInputs = with python3Packages; [ contextlib2 ];
    checkPhase = ''
      py.test
    '';
    # FileNotFoundError: [Errno 2] No such file or directory: '/usr/bin'
    doCheck = false;
    meta = {
      description = "Python bindings for the low-level FUSE API";
      homepage = https://code.google.com/p/python-llfuse/;
      license = stdenv.lib.licenses.lgpl2Plus;
      platforms = stdenv.lib.platforms.unix;
      maintainers = with stdenv.lib.maintainers; [ bjornfor ];
    };
  };

in python3Packages.buildPythonApplication rec {
  name = "attic-${version}";
  version = "0.16";
  namePrefix = "";

  src = fetchzip {
    name = "${name}-src";
    url = "https://github.com/jborg/attic/archive/${version}.tar.gz";
    sha256 = "008566hhsd3ck70ql0fdn4vaqjfcnf493gwd49d6294f8r7qn06z";
  };

  propagatedBuildInputs = with python3Packages;
    [ cython msgpack openssl acl llfuse-0-41 ];

  preConfigure = ''
    export ATTIC_OPENSSL_PREFIX="${openssl.dev}"
    substituteInPlace setup.py --replace "version=versioneer.get_version()" "version='${version}'"
  '';

  meta = with stdenv.lib; {
    description = "A deduplicating backup program";
    homepage = https://attic-backup.org;
    license = licenses.bsd3;
    maintainers = [ maintainers.wscott ];
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
  };
}
