{ lib
, buildGoModule
, fetchFromGitHub
, testers
, tailer
}:

buildGoModule rec {
  pname = "tailer";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "hionay";
    repo = "tailer";
    rev = "v${version}";
    hash = "sha256-gPezz2ksqdCffgdAHwU2NMTar2glp5YGfA5C+tMYPtE=";
  };

  vendorHash = "sha256-nQqSvfN+ed/g5VkbD6XhZNA1G3CGGfwFDdadJ5+WoD0=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = tailer;
    };
  };

  meta = with lib; {
    description = "A CLI tool to insert lines when command output stops";
    homepage = "https://github.com/hionay/tailer";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "tailer";
  };
}
