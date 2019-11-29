{ stdenv, fetchFromGitHub, fuse3, bzip2, zlib, attr, cmake }:

stdenv.mkDerivation {
  pname = "apfs-fuse-unstable";
  version = "2019-07-23";

  src = fetchFromGitHub {
    owner  = "sgan81";
    repo   = "apfs-fuse";
    rev    = "309ecb030f38edac4c10fa741a004c5eb7a23e15";
    sha256 = "0wq6rlqi00m5dp5gbzy65i1plm40j6nsm7938zvfgx5laal4wzr2";
    fetchSubmodules = true;
  };

  buildInputs = [ fuse3 bzip2 zlib attr ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage    = "https://github.com/sgan81/apfs-fuse";
    description = "FUSE driver for APFS (Apple File System)";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ ealasu ];
    platforms   = platforms.linux;
  };

}
