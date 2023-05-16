{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "xe";
<<<<<<< HEAD
  version = "1.0";
=======
  version = "0.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "xe";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-yek6flBhgjSeN3M695BglUfcbnUGp3skzWT2W/BxW8Y=";
=======
    sha256 = "04jr8f6jcijr0bsmn8ajm0aj35qh9my3xjsaq64h8lwg5bpyn29x";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple xargs and apply replacement";
    homepage = "https://github.com/chneukirchen/xe";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ cstrahan ];
  };
}
