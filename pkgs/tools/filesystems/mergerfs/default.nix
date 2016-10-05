{ stdenv, fetchgit, fuse, pkgconfig, which, attr, pandoc, git }:

stdenv.mkDerivation rec {
  name = "mergerfs-${version}";
  version = "2.16.1";

  # not using fetchFromGitHub because of changelog being built with git log
  src = fetchgit {
    url = "https://github.com/trapexit/mergerfs";
    rev = "refs/tags/${version}";
    sha256 = "12fqgk54fnnibqiq82p4g2k6qnw3iy6dd64csmlf73yi67za5iwf";
    deepClone = true;
  };

  buildInputs = [ fuse pkgconfig which attr pandoc git ];

  makeFlags = [ "PREFIX=$(out)" "XATTR_AVAILABLE=1" ];

  meta = {
    description = "A FUSE based union filesystem";
    homepage = https://github.com/trapexit/mergerfs;
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ makefu ];
  };
}
