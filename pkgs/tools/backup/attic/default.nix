{ stdenv, fetchzip, python3Packages, openssl, acl }:

python3Packages.buildPythonApplication rec {
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
