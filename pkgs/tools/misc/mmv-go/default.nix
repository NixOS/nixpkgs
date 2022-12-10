{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mmv-go";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "mmv";
    rev = "v${version}";
    sha256 = "sha256-n7yW+0cabJGDgppt6Qcj7ID3sD85094NDOPk2o9xDwY=";
  };

  vendorSha256 = "sha256-3Xk8S2Em28r5R7894Ubo2OOlGhrKplV/gY4ftCjPvMo=";

  ldflags = [ "-s" "-w" "-X main.revision=${src.rev}" ];

  meta = with lib; {
    homepage = "https://github.com/itchyny/mmv";
    description = "Rename multiple files using your $EDITOR";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "mmv";
  };
}
