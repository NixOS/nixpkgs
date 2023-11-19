{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "mdr";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "MichaelMure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ibM3303pXnseAFP9qFTOzj0G/SxRPX+UeRfbJ+MCABk=";
  };

  vendorHash = "sha256-5jzU4EybEGKoEXCFhnu7z4tFRS9fgf2wJXhkvigRM0E=";

  ldflags = [
    "-s"
    "-w"
    "-X main.GitCommit=${src.rev}"
    "-X main.GitLastTag=${version}"
    "-X main.GitExactTag=${version}"
  ];

  meta = with lib; {
    description = "MarkDown Renderer for the terminal";
    homepage = "https://github.com/MichaelMure/mdr";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
