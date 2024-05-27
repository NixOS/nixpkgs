{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mmv-go";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "mmv";
    rev = "v${version}";
    sha256 = "sha256-DNLiW0QX7WrBslwVCbvydLnE6JAcfcRALYqwsK/J5x0=";
  };

  vendorHash = "sha256-HHGiMSBu3nrIChSYaEu9i22nwhLKgVQkPvbTMHBWwAE=";

  ldflags = [ "-s" "-w" "-X main.revision=${src.rev}" ];

  meta = with lib; {
    homepage = "https://github.com/itchyny/mmv";
    description = "Rename multiple files using your $EDITOR";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "mmv";
  };
}
