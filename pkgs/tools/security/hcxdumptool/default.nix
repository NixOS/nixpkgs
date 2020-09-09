{ stdenv, lib, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "hcxdumptool";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxdumptool";
    rev = version;
    sha256 = "0v6dq6x2mrmavazknmhb08ks53773sll367anfrrramild8350bh";
  };

  buildInputs = [ openssl ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/ZerBea/hcxdumptool";
    description = "Small tool to capture packets from wlan devices";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ danielfullmer ];
  };
}
