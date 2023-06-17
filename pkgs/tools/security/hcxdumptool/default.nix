{ stdenv, lib, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "hcxdumptool";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxdumptool";
    rev = version;
    sha256 = "sha256-29AG5vzWgVOzJvlx1TiYA/veXaQvOwfHa8QYq+qMnq0=";
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
