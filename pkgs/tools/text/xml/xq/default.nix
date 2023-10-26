{ lib
, buildGoModule
, fetchFromGitHub
, testers
, xq-xml
}:

buildGoModule rec {
  pname = "xq";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "sibprogrammer";
    repo = "xq";
    rev = "v${version}";
    hash = "sha256-bhJ8zMZQZn/VzhulkfGOW+uyS8E43TIREAvKIsEPonA=";
  };

  vendorHash = "sha256-iJ1JMvIJqXLkZXuzn2rzKnLbiagTocg/6mJN3Pgd/4w=";

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
