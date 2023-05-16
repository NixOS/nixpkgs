{ lib
, stdenv
, fetchFromGitHub
, openssl
}:

stdenv.mkDerivation rec {
  pname = "sslscan";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "2.0.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rbsec";
    repo = "sslscan";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-sEWWmfTdzqDoTyERoJUZ1/xqeRFcshc72mXzecij4TI=";
=======
    sha256 = "sha256-1j5p9cuSxc8u6/+puP9ywHEljeva18m+WO3M8gbpkIU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ openssl ];

  makeFlags = [ "PREFIX=$(out)" "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    description = "Tests SSL/TLS services and discover supported cipher suites";
    homepage = "https://github.com/rbsec/sslscan";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fpletz globin ];
  };
}
