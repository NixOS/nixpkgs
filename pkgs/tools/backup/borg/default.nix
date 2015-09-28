{ stdenv, fetchzip, python3Packages, openssl, acl }:

python3Packages.buildPythonPackage rec {
  name = "borg-${version}";
  version = "0.23.0";
  namePrefix = "";

  src = fetchzip {
    name = "${name}-src";
    url = "https://github.com/borgbackup/borg/archive/${version}.tar.gz";
    sha256 = "1ns00bhrh4zm1s70mm32gnahj7yh4jdpkb8ziarhvcnknz7aga67";
  };

  propagatedBuildInputs = with python3Packages;
    [ cython msgpack openssl acl llfuse tox detox ];

  preConfigure = ''
    export BORG_OPENSSL_PREFIX="${openssl}"
  '';

  meta = with stdenv.lib; {
    description = "A deduplicating backup program (attic fork)";
    homepage = https://borgbackup.github.io/;
    license = licenses.bsd3;
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
  };
}
