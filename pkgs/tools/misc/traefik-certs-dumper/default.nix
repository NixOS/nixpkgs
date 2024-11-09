{ fetchFromGitHub, buildGoModule, lib }:

buildGoModule rec {
  pname = "traefik-certs-dumper";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "ldez";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ezZ1/hx3BpCPXTo6d+EUAjYgkPLJ6SPweWYihuvr+zo=";
  };

  vendorHash = "sha256-/JZvxPR2Faf/cgV+cMCSlrjTuvQw3TNjXRbQeB2nxNQ=";
  excludedPackages = "integrationtest";

  meta = with lib; {
    description = "dump ACME data from traefik to certificates";
    homepage = "https://github.com/ldez/traefik-certs-dumper";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "traefik-certs-dumper";
  };
}
