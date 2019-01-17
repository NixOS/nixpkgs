{ stdenv, fetchFromGitHub, cmake, fuse, zlib, bzip2, openssl, libxml2, icu } :

stdenv.mkDerivation rec {
  name = "darling-dmg-${version}";
  version = "1.0.4+git20180914";

  src = fetchFromGitHub {
    owner = "darlinghq";
    repo = "darling-dmg";
    rev = "97a92a6930e43cdbc9dedaee62716e3223deb027";
    sha256 = "1bngr4827qnl4s2f7z39wjp13nfm3zzzykjshb43wvjz536bnqdj";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ fuse openssl zlib bzip2 libxml2 icu ];

  meta = {
    homepage = http://www.darlinghq.org/;
    description = "Darling lets you open macOS dmgs on Linux";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3;
  };
}
