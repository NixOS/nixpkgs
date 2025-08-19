{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tflint-ruleset-aws";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-R2Njm5RpjdSGMi9qdu8wTEEM5YyMaf/UAkdBVYPl9W0=";
  };

  vendorHash = "sha256-Sn7uze6uSI2O824UjG8pFMQ1KsnwdknRzOT9czpNnD4=";

  postPatch = ''
    # some automation for creating new releases on GitHub, which we don't need
    rm -rf tools/release
  '';

  # upstream Makefile also does a  go test $(go list ./... | grep -v integration)
  preCheck = ''
    rm integration/integration_test.go
  '';

  postInstall = ''
    # allow use as a versioned dependency, i.e., with `source = ...` and
    # `version = ...` in `.tflintrc`:
    mkdir -p $out/github.com/terraform-linters/${pname}/${version}
    mv $out/bin/${pname} $out/github.com/terraform-linters/${pname}/${version}/

    # allow use as an unversioned dependency, e.g., if one wants `.tflintrc` to
    # solely rely on Nix to pin versions:
    ln -s $out/github.com/terraform-linters/${pname}/${version}/${pname} $out/

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
