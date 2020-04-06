{ stdenv, fetchFromGitHub, curl, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "hcxtools";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = pname;
    rev = version;
    sha256 = "0r7pjz89chgb7zl2pqgw3zb1z8cgwp0nxmqvmkv0jn1m9dw3f44f";
  };

  buildInputs = [ curl openssl zlib ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with stdenv.lib; {
    description = "Tools for capturing wlan traffic and conversion to hashcat and John the Ripper formats";
    homepage = "https://github.com/ZerBea/hcxtools";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dywedir ];
  };
}
