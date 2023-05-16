{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fsql";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "kshvmdn";
    repo = "fsql";
    rev = "v${version}";
    sha256 = "sha256-6KqlpFBaAWrlEjkFQhOEic569+eoYVAsnhMrg8AEPV4=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-xuD7/gTssf1Iu1VuIRysjtUjve16gozOq0Wz4w6mIB8=";
=======
  vendorSha256 = "sha256-xuD7/gTssf1Iu1VuIRysjtUjve16gozOq0Wz4w6mIB8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Search through your filesystem with SQL-esque queries";
    homepage = "https://github.com/kshvmdn/fsql";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
