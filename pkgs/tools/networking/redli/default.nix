{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "redli";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "IBM-Cloud";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-AeIGlRsUWK6q0GJJFmvJwpuGy312VPsMhkxMqDDzay4=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-AeIGlRsUWK6q0GJJFmvJwpuGy312VPsMhkxMqDDzay4=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A humane alternative to the Redis-cli and TLS";
    homepage = "https://github.com/IBM-Cloud/redli";
    license = licenses.asl20;
    maintainers = with maintainers; [ tchekda ];
  };
}
