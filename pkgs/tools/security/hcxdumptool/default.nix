{ stdenv, lib, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "hxcdumptool";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxdumptool";
    rev = version;
    sha256 = "0rh19lblz8wp8q2x123nlwvxq1pjq9zw12w18z83v2l2knjbc524";
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
