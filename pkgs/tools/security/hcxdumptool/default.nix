{ stdenv, lib, fetchFromGitHub, openssl, hcxdumptool, testVersion }:

stdenv.mkDerivation rec {
  pname = "hcxdumptool";
  version = "6.1.4";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxdumptool";
    rev = version;
    sha256 = "14rwcchqpsxyzvk086d7wbi5qlcxj4jcmafzgvkwzrpbspqh8p24";
  };

  buildInputs = [ openssl ];

  installFlags = [ "PREFIX=$(out)" ];

  passthru.tests.version = testVersion { package = hcxdumptool; };

  meta = with lib; {
    homepage = "https://github.com/ZerBea/hcxdumptool";
    description = "Small tool to capture packets from wlan devices";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ danielfullmer ];
  };
}
