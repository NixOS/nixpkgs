{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tflint-ruleset-aws";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2Qr+tG1cmDF9MdsLMOnIdSGWMVAYYVgobE/SuJZRqJg=";
  };

  vendorHash = "sha256-P3yqDqVoC6XCX5OJ8kTvIk6Qq8X02Be51TajIkZxdbI=";

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
