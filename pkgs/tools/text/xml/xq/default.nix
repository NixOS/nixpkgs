{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  xq-xml,
}:

buildGoModule rec {
  pname = "xq";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "sibprogrammer";
    repo = "xq";
    rev = "v${version}";
    hash = "sha256-g1d5sS3tgxP2VRogWG/5OXezDsJuQ6e724te+Oj3r24=";
  };

  vendorHash = "sha256-Oy/BBE6qCKJQRNDn6UiBr+/Psgi3A9Eaytmbmjt7eq8=";

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
    mainProgram = "xq";
    homepage = "https://github.com/sibprogrammer/xq";
    changelog = "https://github.com/sibprogrammer/xq/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
