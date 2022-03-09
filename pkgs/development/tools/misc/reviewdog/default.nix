{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reviewdog";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mMpbV02yoso+Nvq1wkenvlbmTsOcTlpfKIhvyttrIf8=";
  };

  vendorSha256 = "sha256-UQbZjN7GaGXvBmMPAeQqaWriV+t3XSUd6hUOuZCiR24=";

  doCheck = false;

  subPackages = [ "cmd/reviewdog" ];

  ldflags = [ "-s" "-w" "-X github.com/reviewdog/reviewdog/commands.Version=${version}" ];

  meta = with lib; {
    description = "Automated code review tool integrated with any code analysis tools regardless of programming language";
    homepage = "https://github.com/reviewdog/reviewdog";
    changelog = "https://github.com/reviewdog/reviewdog/raw/v${version}/CHANGELOG.md";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
