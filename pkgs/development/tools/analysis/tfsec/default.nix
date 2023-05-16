{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfsec";
<<<<<<< HEAD
  version = "1.28.4";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "tfsec";
    rev = "refs/tags/v${version}";
    hash = "sha256-WMmRCjKBtPT45it6iUQh5D7TBc8glt+dppksBvDhTN4=";
=======
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-44DN3lV9BLBFr6kkD3IcamQg+t+xUqqao83f0nBKZvI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X=github.com/aquasecurity/tfsec/version.Version=v${version}"
=======
    "-X github.com/aquasecurity/tfsec/version.Version=v${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ## not sure if this is needed (https://github.com/aquasecurity/tfsec/blob/master/.goreleaser.yml#L6)
    # "-extldflags '-fno-PIC -static'"
  ];

<<<<<<< HEAD
  vendorHash = "sha256-7OTMJhW1Q1z/TOFa4oRCEIPF0cN8gZLdaQglqszXHdw=";
=======
  vendorSha256 = "sha256-NQUDeNAWSWcIoSZjdbaFQTB3nMFGbLZLUDNFHMk6Enw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [
    "cmd/tfsec"
    "cmd/tfsec-docs"
    "cmd/tfsec-checkgen"
  ];

  meta = with lib; {
    description = "Static analysis powered security scanner for terraform code";
    homepage = "https://github.com/aquasecurity/tfsec";
<<<<<<< HEAD
    changelog = "https://github.com/aquasecurity/tfsec/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab marsam peterromfeldhk ];
  };
}
