{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule rec {
  pname = "goodhosts";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "goodhosts";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-ZasS7AYGYPV+nzp9JbJC5pD0yQ+ik+QnuL+3qC1uqFk=";
  };

  ldflags = [
    "-s -w -X main.version=${version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/goodhosts
  '';

  vendorHash = "sha256-t/pdJWz6rLnBbH8iq9Nqy+E+DD2770UCEcowwStPdqM=";

  meta = with lib; {
    description = "A CLI tool for managing hostfiles";
    license = licenses.mit;
    homepage = "https://github.com/goodhosts/cli/tree/main";
    maintainers = with maintainers; [ schinmai-akamai ];
    mainProgram = "goodhosts";
  };
}
