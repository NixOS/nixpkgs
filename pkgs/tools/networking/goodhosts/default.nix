{ lib
, buildGoModule
, fetchFromGitHub
, testers
}:

buildGoModule rec {
  pname = "goodhosts";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "goodhosts";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-VXOMyYM4jS3gYxm3WiKw3uKeC535ppd9iHumPiupGbc=";
  };

  ldflags = [
    "-s -w -X main.version=${version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/goodhosts
  '';

  vendorHash = "sha256-pL1z8cfnzcmX5iMVHQJGXYmzGuf8bp4Txbqoh5wSPWQ=";

  meta = with lib; {
    description = "A CLI tool for managing hostfiles";
    license = licenses.mit;
    homepage = "https://github.com/goodhosts/cli/tree/main";
    maintainers = with maintainers; [ schinmai-akamai ];
    mainProgram = "goodhosts";
  };
}
