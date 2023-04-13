{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tflint-ruleset-aws";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uHl13TNn+ero9NiL2Fnly+4H7f9eti4UoEXHKJ+DHKo=";
  };

  vendorHash = "sha256-mQzCqLJ3Y9l+BbfurtD/f/PRuXX+zYMeg8bPIjj05Nk=";

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
    description = "TFLint ruleset plugin for Terraform AWS Provider";
    platforms = platforms.unix;
    maintainers = with maintainers; [ flokli ];
    license = with licenses; [ mpl20 ];
  };
}
