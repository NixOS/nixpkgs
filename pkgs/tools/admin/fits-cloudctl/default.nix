{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.11.10";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-1jJDgjkay1IsWMWoRf6iRWFr7685uE9Kr9DCreH13CM=";
  };

  vendorHash = "sha256-rHUPtscmG28PyNWzoayThbRt+3t9ewBe8vsRqtVc1WM=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
