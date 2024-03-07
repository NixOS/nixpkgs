{ lib
, buildGoModule
, fetchFromGitHub
, testers
, xq-xml
}:

buildGoModule rec {
  pname = "xq";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "sibprogrammer";
    repo = "xq";
    rev = "v${version}";
    hash = "sha256-Zg1ARyDXklKBR5WhqRakWT/KcG5796h2MxsBjPCWSjs=";
  };

  vendorHash = "sha256-NNhndc604B0nGnToS7MtQzpn3t3xPl5DlkCafc/EyKE=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.commit=${src.rev}"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = xq-xml;
    };
  };

  meta = with lib; {
    description = "Command-line XML and HTML beautifier and content extractor";
    homepage = "https://github.com/sibprogrammer/xq";
    changelog = "https://github.com/sibprogrammer/xq/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
