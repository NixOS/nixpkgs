{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tflint-ruleset-google";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cflmuvILMJX7jsz6OKPcaN/KezvWiqiv20Sw4vJ/mUk=";
  };

  vendorHash = "sha256-xxSOjnzqESCOWtXsAGuTwVEoinvBNuJFaxDrIVc1O08=";

  # upstream Makefile also does a go test $(go list ./... | grep -v integration)
  preCheck = ''
    rm integration/integration_test.go
  '';

  subPackages = [ "." ];

  postInstall = ''
    mkdir -p $out/github.com/terraform-linters/${pname}/${version}
    mv $out/bin/${pname} $out/github.com/terraform-linters/${pname}/${version}/
  '';

  meta = with lib; {
    homepage = "https://github.com/terraform-linters/tflint-ruleset-google";
    description = "TFLint ruleset plugin for Terraform Google Provider";
    platforms = platforms.unix;
    maintainers = with maintainers; [ john-rodewald ];
    license = with licenses; [ mpl20 ];
  };
}
