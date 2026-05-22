{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tflint-ruleset-google";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Lzre5IMgf1K0S+932R8GqZHdrLp0eElvpxPpy93zNyo=";
  };

  vendorHash = "sha256-mR9EBeADVFMpykd+CV0tjX95Mn8hJbszLFqNL204IuQ=";

  # upstream Makefile also does a go test $(go list ./... | grep -v integration)
  preCheck = ''
    rm integration/integration_test.go
  '';

  subPackages = [ "." ];

  postInstall = ''
    # allow use as a versioned dependency, i.e., with `source = ...` and
    # `version = ...` in `.tflintrc`:
    mkdir -p $out/github.com/terraform-linters/${pname}/${version}
    mv $out/bin/${pname} $out/github.com/terraform-linters/${pname}/${version}/

    # allow use as an unversioned dependency, e.g., if one wants `.tflintrc` to
    # solely rely on Nix to pin versions:
    ln -s $out/github.com/terraform-linters/${pname}/${version}/${pname} $out/
  '';

  meta = {
    homepage = "https://github.com/terraform-linters/tflint-ruleset-google";
    description = "TFLint ruleset plugin for Terraform Google Provider";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ john-rodewald ];
    license = with lib.licenses; [ mpl20 ];
  };
}
