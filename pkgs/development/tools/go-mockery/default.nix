{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-mockery";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "vektra";
    repo = "mockery";
    rev = "v${version}";
    sha256 = "sha256-sOZig47KKKGJmV9QNCa+TwYCxemeVl6xssfExSaaFjY=";
  };

  vendorSha256 = "sha256-//V3ia3YP1hPgC1ipScURZ5uXU4A2keoG6dGuwaPBcA=";

  meta = with lib; {
    homepage = "https://github.com/vektra/mockery";
    description = "A mock code autogenerator for Golang";
    maintainers = with maintainers; [ fbrs ];
    license = licenses.bsd3;
  };
}
