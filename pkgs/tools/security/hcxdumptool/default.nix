{ stdenv, lib, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "hcxdumptool";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxdumptool";
    rev = version;
    sha256 = "sha256-FWBr0uDpefu2MCWQZrMfPJ/MUJcmk9fWMzhtTDmC0L0=";
  };

  buildInputs = [ openssl ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/ZerBea/hcxdumptool";
    description = "Small tool to capture packets from wlan devices";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ danielfullmer ];
  };
}
