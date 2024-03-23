{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.12.17";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    hash = "sha256-nKVCYgecrjCfAx+9aiFJYq2m/E1yFh1Ie2vK4HqusUo=";
  };

  vendorHash = "sha256-xcwJ1tEOCF9BGjcWZPVY/IZkNc2TUtufa7zQfIU4CQQ=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
