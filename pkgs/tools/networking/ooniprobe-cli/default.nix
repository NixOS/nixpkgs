{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.17.5";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    rev = "v${version}";
    hash = "sha256-pzNcyioicAOCAWaEo30T/Dr74sJ1kXvJN0pnuA2JJ7k=";
  };

  vendorHash = "sha256-e8FI678zr6EWKd+rOvPOyq20PJyaXszzcooDFuGWfOU=";

  subPackages = [ "cmd/ooniprobe" ];

  meta = with lib; {
    changelog = "https://github.com/ooni/probe-cli/releases/tag/${src.rev}";
    description = "The Open Observatory of Network Interference command line network probe";
    homepage = "https://ooni.org/install/cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "ooniprobe";
  };
}
