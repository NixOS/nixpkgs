{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "unconvert";
  version = "0-unstable-2023-09-07";

  src = fetchFromGitHub {
    owner = "mdempsky";
    repo = "unconvert";
    rev = "415706980c061b6f71ea923bd206aec88785638f";
    hash = "sha256-MchA8uvy+MyQ/VaglBDTC7j/lNIKAtGeeECLoFfH6pI=";
  };

  vendorHash = "sha256-vZDk+ZNCMP5RRNrgeIowdOKPot7rqM84JhlbfvcQbB4=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Remove unnecessary type conversions from Go source";
    mainProgram = "unconvert";
    homepage = "https://github.com/mdempsky/unconvert";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
  };
}
