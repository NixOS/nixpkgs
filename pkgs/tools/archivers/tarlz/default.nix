{ lib, stdenv, fetchurl, lzip, lzlib, texinfo }:

stdenv.mkDerivation rec {
  pname = "tarlz";
  version = "0.24";
  outputs = [ "out" "man" "info" ];

  nativeBuildInputs = [ lzip texinfo ];
  buildInputs = [ lzlib ];

  src = fetchurl {
    url = "mirror://savannah/lzip/${pname}/${pname}-${version}.tar.lz";
    sha256 = "49838effe95acb29d548b7ef2ddbb4b63face40536df0d9a80a62900c7170576";
  };

  enableParallelBuilding = true;
  makeFlags = [ "CXX:=$(CXX)" ];
  doCheck = !stdenv.isDarwin;

  preCheck = ''
    substituteInPlace testsuite/check.sh \
      --replace '1969-12-31T23:59:59' '''
  '';

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/${pname}.html";
    description =
      "Massively parallel combined implementation of the tar archiver and the lzip compressor";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry ];
  };
}
