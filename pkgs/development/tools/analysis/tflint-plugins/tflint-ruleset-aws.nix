{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tflint-ruleset-aws";
<<<<<<< HEAD
  version = "0.26.0";
=======
  version = "0.21.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-SKPmD34a11ynNmnD2cDTSXgRpUZ7tukaGRO8PQY6T5s=";
  };

  vendorHash = "sha256-JhAAyfDVRZS2QyvXNa61srlZKgsBFeKloeKbcXXpytk=";
=======
    hash = "sha256-uHl13TNn+ero9NiL2Fnly+4H7f9eti4UoEXHKJ+DHKo=";
  };

  vendorHash = "sha256-mQzCqLJ3Y9l+BbfurtD/f/PRuXX+zYMeg8bPIjj05Nk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # upstream Makefile also does a  go test $(go list ./... | grep -v integration)
  preCheck = ''
    rm integration/integration_test.go
  '';

  postInstall = ''
    mkdir -p $out/github.com/terraform-linters/${pname}/${version}
    mv $out/bin/${pname} $out/github.com/terraform-linters/${pname}/${version}/
    # remove other binaries from bin
    rm -R $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/terraform-linters/tflint-ruleset-aws";
<<<<<<< HEAD
    changelog = "https://github.com/terraform-linters/tflint-ruleset-aws/blob/v${version}/CHANGELOG.md";
    description = "TFLint ruleset plugin for Terraform AWS Provider";
=======
    description = "TFLint ruleset plugin for Terraform AWS Provider";
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ flokli ];
    license = with licenses; [ mpl20 ];
  };
}
