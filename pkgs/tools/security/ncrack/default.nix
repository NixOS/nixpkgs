{ lib, stdenv, fetchFromGitHub, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "ncrack";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "nmap";
    repo = "ncrack";
    rev = version;
    sha256 = "1gnv5xdd7n04glcpy7q1mkb6f8gdhdrhlrh8z6k4g2pjdhxlz26g";
  };

  buildInputs = [ openssl zlib ];

  meta = with lib; {
    description = "Network authentication tool";
    homepage = "https://nmap.org/ncrack/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
