{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-migrate";
  version = "4.15.0";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${version}";
    sha256 = "sha256-fl6gPKZlc8K6yD8xHC6XbmCHUJl6nI+X2I4JmXABWdY=";
  };

  vendorSha256 = "sha256-/N1sglGPwb77HLnVOzMYlFPSmeUvWs+wld7Fd7rjWrA=";

  subPackages = [ "cmd/migrate" ];

  meta = with lib; {
    homepage    = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = with maintainers; [ offline ];
    license     = licenses.mit;
    mainProgram = "migrate";
  };
}
