{ stdenv, fetchFromGitHub, cmake, fuse, zlib, bzip2, openssl, libxml2, icu } :

stdenv.mkDerivation rec {
  pname = "darling-dmg";
  version = "1.0.4+git20180914";

  src = fetchFromGitHub {
    owner = "darlinghq";
    repo = "darling-dmg";
    rev = "97a92a6930e43cdbc9dedaee62716e3223deb027";
    sha256 = "1bngr4827qnl4s2f7z39wjp13nfm3zzzykjshb43wvjz536bnqdj";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ fuse openssl zlib bzip2 libxml2 icu ];

  # compat with icu61+ https://github.com/unicode-org/icu/blob/release-64-2/icu4c/readme.html#L554
  CXXFLAGS = [ "-DU_USING_ICU_NAMESPACE=1" ];

  meta = {
    homepage = "https://www.darlinghq.org/";
    description = "Darling lets you open macOS dmgs on Linux";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3;
  };
}
