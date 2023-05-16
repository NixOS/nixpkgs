{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "github-commenter";
<<<<<<< HEAD
  version = "0.19.0";
=======
  version = "0.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-pCcTdj2ZgGIpa6784xkBX29LVu1o5ORqqk9j9wR/V8k=";
  };

  vendorHash = "sha256-etR//FfHRzCL6WEZSqeaKYu3eLjxA0x5mZJRe1yvycQ=";
=======
    sha256 = "sha256-IBo4FAoYX1FmrmQ9mlyyu1TGLY7dlH7pWalBoRb2puE=";
  };

  vendorSha256 = "sha256-H1SnNG+/ALYs7h/oT8zWBhAXOuCFY0Sto2ATBBZg2ek=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Command line utility for creating GitHub comments on Commits, Pull Request Reviews or Issues";
    license = licenses.asl20;
    homepage = "https://github.com/cloudposse/github-commenter";
    maintainers = [ maintainers.mmahut ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
