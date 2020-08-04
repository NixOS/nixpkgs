{ stdenv, lib, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "hcxdumptool";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxdumptool";
    rev = version;
    sha256 = "10dhv8lgsciw6w9r328k50pv1ldldf9wikplgh0dq98djlf0l961";
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
