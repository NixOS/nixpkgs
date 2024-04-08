{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fx";
  version = "32.0.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    hash = "sha256-AbMm/vXt/s/evTxB2oE/6qGbfNtNXVSiYj4n4261iNk=";
  };

  vendorHash = "sha256-fnWjeQo5370ofFRQRmUnqvj2vutcZcnKar+/sTS2mJw=";

  meta = with lib; {
    description = "Terminal JSON viewer";
    mainProgram = "fx";
    homepage = "https://github.com/antonmedv/fx";
    changelog = "https://github.com/antonmedv/fx/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
