{ stdenv, lib, fetchzip, bzip2, lzo, openssl, zlib }:

stdenv.mkDerivation rec {
  version = "0.11.0";
  pname = "quickbms";

  src = fetchzip {
    url = "https://aluigi.altervista.org/papers/quickbms-src-${version}.zip";
    hash = "sha256-uQKTE36pLO8uhrX794utqaDGUeyqRz6zLCQFA7DYkNc=";
  };

  buildInputs = [ bzip2 lzo openssl zlib ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Universal script based file extractor and reimporter";
    homepage = "https://aluigi.altervista.org/quickbms.htm";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
