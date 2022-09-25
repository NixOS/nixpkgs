{ lib, stdenv, fetchurl, lzip, lzlib, texinfo }:

stdenv.mkDerivation rec {
  pname = "tarlz";
  version = "0.23";
  outputs = [ "out" "man" "info" ];

  nativeBuildInputs = [ lzip texinfo ];
  buildInputs = [ lzlib ];

  src = fetchurl {
    url = "mirror://savannah/lzip/${pname}/${pname}-${version}.tar.lz";
    sha256 = "3cefb4f889da25094f593b43a91fd3aaba33a02053a51fb092e9b5e8adb660a3";
    # upstream publishes digests in hex
  };

  enableParallelBuilding = true;
  makeFlags = [ "CXX:=$(CXX)" ];
  doCheck = !stdenv.isDarwin;

  preCheck = ''
    substituteInPlace testsuite/check.sh \
      --replace '1969-12-31T23:59:59' '''
  ''; # do not use this date as a mtime with this package, this is your only warning

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/${pname}.html";
    description =
      "Massively parallel combined implementation of the tar archiver and the lzip compressor";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry ];
  };
}
