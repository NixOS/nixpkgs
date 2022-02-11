{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreman";
  version = "0.3.9";
  rev = "df1209e7cdbad10aecc0aa75d332bc32822925f5";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "goreman";
    rev = "v${version}";
    sha256 = "1irjf5i5ybdchyn42bamfq8pj3w00p633h1gg202n0vsr39h0bxw";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.revision=${builtins.substring 0 7 rev}"
  ];

  vendorSha256 = "sha256-+RFh6Ppxxs7P7DWqOBeEJTvPsBgOfopMjx22hPEI1/U=";

  doCheck = false;

  meta = with lib; {
    description = "foreman clone written in go language";
    homepage = "https://github.com/mattn/goreman";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
