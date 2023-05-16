{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraformer";
<<<<<<< HEAD
  version = "0.8.24";
=======
  version = "0.8.22";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-paBj2vaBicXHMEei2HPW+d4fXWf8VnVhvcanXmo/5KI=";
  };

  vendorHash = "sha256-Rh2ZGSfa95Yw8GGjsZjwmj0o4qKpygbPsLCbzUTOBxQ=";
=======
    sha256 = "sha256-TuzQ9qIpioKK4tc1J9Spxt52716Z3yTEufyaRDL57gI=";
  };

  vendorSha256 = "sha256-fcCvwjqSTeFo0AwTVwWTdygvIPf0EUnZkWqNrQ6eugI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI tool to generate terraform files from existing infrastructure (reverse Terraform). Infrastructure to Code";
    homepage = "https://github.com/GoogleCloudPlatform/terraformer";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
