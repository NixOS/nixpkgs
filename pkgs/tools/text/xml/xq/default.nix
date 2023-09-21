{ lib
, buildGoModule
, fetchFromGitHub
, testers
, xq
}:

buildGoModule rec {
  pname = "xq";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "sibprogrammer";
    repo = "xq";
    rev = "v${version}";
    hash = "sha256-Z14x1b25wKNm9fECkNqGJglK/Z8Xq8VHmYfp5aEvvMU=";
  };

  vendorHash = "sha256-CP4QsrTkFcOLDxnFc0apevXRmXHA9aJSU4AK9+TAxOU=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.commit=${src.rev}"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = xq;
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
