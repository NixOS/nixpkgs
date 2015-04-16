{ stdenv, fetchzip, python3Packages, openssl, acl }:

python3Packages.buildPythonPackage rec {
  name = "attic-0.15";
  namePrefix = "";

  src = fetchzip {
    name = "${name}-src";
    url = "https://github.com/jborg/attic/archive/0.15.tar.gz";
    sha256 = "0bing5zg82mwvdi27jl77ardw65zaq4996k4677gz2lq7p7b4gd7";
  };

  propagatedBuildInputs = with python3Packages;
    [ cython msgpack openssl acl llfuse ];

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
