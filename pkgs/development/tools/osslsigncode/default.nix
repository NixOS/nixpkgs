{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, libgsf
, pkgconfig
, openssl
, curl
}:

stdenv.mkDerivation rec {
  pname = "osslsigncode";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "mtrojnar";
    repo = pname;
    rev = version;
    sha256 = "0iwxdzqan2bswz62pmwjcyh01vs6ifpdcannw3s192gqzac1lgg3";
  };

  nativeBuildInputs = [ autoreconfHook libgsf pkgconfig openssl curl ];

  meta = with lib; {
    homepage = "https://github.com/mtrojnar/osslsigncode";
    description = "OpenSSL based Authenticode signing for PE/MSI/Java CAB files";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mmahut prusnak ];
    platforms = platforms.all;
  };
}
