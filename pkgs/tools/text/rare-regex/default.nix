{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, withPcre2 ? stdenv.isLinux
, pcre2
, testers
, rare-regex
}:

buildGoModule rec {
  pname = "rare";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "zix99";
    repo = "rare";
    rev = version;
    hash = "sha256-v3zczT3PMSm2AMKVnVdDxsCpYA8QhZcmOCuiQiz5hFo=";
  };

  vendorHash = "sha256-wUOtxNjL/4MosACCzPTWKWrnMZhxINfN1ppkRsqDh9M=";

  buildInputs = lib.optionals withPcre2 [
    pcre2
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.buildSha=${src.rev}"
  ];

  tags = lib.optionals withPcre2 [
    "pcre2"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = rare-regex;
    };
  };

  meta = with lib; {
    description = "A fast text scanner/regex extractor and realtime summarizer";
    homepage = "https://rare.zdyn.net";
    changelog = "https://github.com/zix99/rare/releases/tag/${src.rev}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}
