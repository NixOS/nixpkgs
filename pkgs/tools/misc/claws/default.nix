{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "claws";
  version = "0.4.1";

  src = fetchFromGitHub {
    rev = version;
    owner = "thehowl";
    repo = pname;
    hash = "sha256-3zzUBeYfu9x3vRGX1DionLnAs1e44tFj8Z1dpVwjdCg=";
  };

  vendorHash = "sha256-FP+3Rw5IdCahhx9giQrpepMMtF1pWcyjNglrlu9ju0Q=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/thehowl/claws";
    description = "Interactive command line client for testing websocket servers";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "claws";
  };
}
