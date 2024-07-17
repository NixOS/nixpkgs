{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tflint-ruleset-aws";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sgAr4kUBjKIH+DgI5XqH/Zs3uL0yiYwlBa6vO0m++xM=";
  };

  vendorHash = "sha256-B2QFjJKwfQYZP8ypiv7bNkFNr3ejP42WA/bmv4Jz46c=";

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
    changelog = "https://github.com/terraform-linters/tflint-ruleset-aws/blob/v${version}/CHANGELOG.md";
    description = "TFLint ruleset plugin for Terraform AWS Provider";
    maintainers = with maintainers; [ flokli ];
    license = with licenses; [ mpl20 ];
  };
}
