{ fetchurl, lib, stdenv, flex, bison }:

stdenv.mkDerivation rec {
  pname = "unfs3";
  version = "0.9.22";

  src = fetchurl {
    url = "mirror://sourceforge/unfs3/${pname}-${version}.tar.gz";
    sha256 = "076zkyqkn56q0a8n3h65n1a68fknk4hrrp6mbhajq5s1wp5248j8";
  };

  nativeBuildInputs = [ flex bison ];

  configureFlags = [ "--disable-shared" ];

  doCheck = false;                                # no test suite

  meta = {
    description = "User-space NFSv3 file system server";

    longDescription =
      '' UNFS3 is a user-space implementation of the NFSv3 server
         specification.  It provides a daemon for the MOUNT and NFS
         protocols, which are used by NFS clients for accessing files on the
         server.
      '';

    homepage = "http://unfs3.sourceforge.net/";

    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];

    # https://github.com/unfs3/unfs3/issues/13
    broken = true;
  };
}
