{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.12.16";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    hash = "sha256-5Uf4glKRbxlC7ZdBW51Ter9SBt5rwas+eD4KYWOqPss=";
  };

  vendorHash = "sha256-GFMnBd5HmjFcMhayL1enQuNxXyVdLb6RLakHNxguXks=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
