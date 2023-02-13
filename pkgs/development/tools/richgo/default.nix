{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "richgo";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "kyoh86";
    repo = "richgo";
    rev = "v${version}";
    sha256 = "sha256-a8CxJKk9fKGYTDtY/mU/3gcdIeejg20sL8Tm4ozgDl4=";
  };

  vendorSha256 = "sha256-j2RZOt5IRb2oEQ6sFu+nXpVkDsnppA6h9YT4F7AiCoY=";

  meta = with lib; {
    description = "Enrich `go test` outputs with text decorations";
    homepage = "https://github.com/kyoh86/richgo";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
