{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, python3
, curl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "osslsigncode";
  version = "2.8";

  src = fetchFromGitHub {
    owner = "mtrojnar";
    repo = pname;
    rev = version;
    sha256 = "sha256-FcrymV0n/Bv0cS9Dx6sG+ifilBiPfaG+xpQvH9mvylQ=";
  };

  nativeBuildInputs = [ cmake pkg-config python3 ];

  buildInputs = [ curl openssl ];

  meta = with lib; {
    homepage = "https://github.com/mtrojnar/osslsigncode";
    description = "OpenSSL based Authenticode signing for PE/MSI/Java CAB files";
    mainProgram = "osslsigncode";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mmahut prusnak ];
    platforms = platforms.all;
  };
}
