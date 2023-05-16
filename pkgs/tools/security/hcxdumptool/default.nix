{ stdenv, lib, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "hcxdumptool";
<<<<<<< HEAD
  version = "6.3.1";
=======
  version = "6.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxdumptool";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-FWBr0uDpefu2MCWQZrMfPJ/MUJcmk9fWMzhtTDmC0L0=";
=======
    sha256 = "sha256-29AG5vzWgVOzJvlx1TiYA/veXaQvOwfHa8QYq+qMnq0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
