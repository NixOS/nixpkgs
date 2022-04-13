{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "bump";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "mroth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tgTG/QlDxX1Ns0WpcNjwr/tvsdtgap7RcxX/JuYcxw8=";
  };

  vendorSha256 = "sha256-ZeKokW6jMiKrXLfnxwEBF+wLuFQufnPUnA/EnuhvrwI=";

  ldflags = [
    "-X main.buildVersion=${version}" "-X main.buildCommit=${version}" "-X main.buildDate=1970-01-01"
  ];

  preCheck = ''
    # git_test.go:55: repository does not exist
    substituteInPlace git_test.go --replace "Test_githubRepoDetect" "Skip_githubRepoDetect"
  '';

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/mroth/bump";
    description = "CLI tool to draft a GitHub Release for the next semantic version";
    maintainers = with maintainers; [ doronbehar ];
  };
}
