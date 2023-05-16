{ buildGoModule, fetchFromGitHub, lib, cf-terraforming, testers }:

buildGoModule rec {
  pname = "cf-terraforming";
<<<<<<< HEAD
  version = "0.13.0";
=======
  version = "0.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cf-terraforming";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-s2xsFJ+8ivkdG2F52iRdTbJDEw8ALmFDR7Ct6d84p+s=";
  };

  vendorHash = "sha256-pe5ieCstUe3ZHlJs83lzwNS2qAIhIGJG9E5P4Ri3E/s=";
=======
    sha256 = "sha256-HCJYLU3eo1C06qp8sb2MsDoLrD0bDeu5WEeGCrOucn4=";
  };

  vendorHash = "sha256-HLKk64PcJUjKfY4pIwI2OXnjqFF1EkYlWOi0aWOVSbk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ldflags = [ "-X github.com/cloudflare/cf-terraforming/internal/app/cf-terraforming/cmd.versionString=${version}" ];

  # The test suite insists on downloading a binary release of Terraform from
  # Hashicorp at runtime, which isn't going to work in a nix build
  doCheck = false;

  passthru.tests = testers.testVersion {
    package = cf-terraforming;
    command = "cf-terraforming version";
  };

  meta = with lib; {
    description = "A command line utility to facilitate terraforming your existing Cloudflare resources";
    homepage = "https://github.com/cloudflare/cf-terraforming/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ benley ];
  };
}
