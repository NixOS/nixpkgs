{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lr";
<<<<<<< HEAD
  version = "1.6";
=======
  version = "1.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-TcP0jLFemdmWzGa4/RX7N6xUUTgKsI7IEOD7GfuuPWI=";
=======
    sha256 = "1wv2acm4r5y5gg6f64v2hiwpg1f3lnr4fy1a9zssw77fmdc7ys3j";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/chneukirchen/lr";
    description = "List files recursively";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ vikanezrimaya ];
  };
}
