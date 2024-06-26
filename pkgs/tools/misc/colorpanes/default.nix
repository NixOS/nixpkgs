{ lib, rustPlatform, fetchFromGitea }:

rustPlatform.buildRustPackage rec {
  pname = "colorpanes";
  version = "3.0.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = pname;
    rev = "v${version}";
    sha256 = "qaOH+LXNDq+utwyI1yzHWNt25AvdAXCTAziGV9ElroU=";
  };

  cargoSha256 = "eJne4OmV4xHxntTb8HE+2ghX1hZLE3WQ3QqsjVm9E4M=";

  postInstall = ''
    ln -s $out/bin/colp $out/bin/colorpanes
  '';

  meta = with lib; {
    description = "Panes in the 8 bright terminal colors with shadows of the respective darker color";
    homepage = "https://codeberg.org/annaaurora/colorpanes";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ annaaurora ];
  };
}
