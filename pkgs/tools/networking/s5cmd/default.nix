{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "s5cmd";
<<<<<<< HEAD
  version = "2.2.0";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "peak";
    repo = "s5cmd";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-4Jx9hgjj+rthiyB7eKXNcbBv9oJWfwHanPO7bZ4J/K0=";
  };

  vendorHash = null;

  # Skip e2e tests requiring network access
  excludedPackages = [ "./e2e" ];
=======
    sha256 = "sha256-9G0GSMNLYeIrbq7zctM3OCRcEZF1giEt+u5g3lTX96M=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/peak/s5cmd";
    description = "Parallel S3 and local filesystem execution tool";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
  };
}
