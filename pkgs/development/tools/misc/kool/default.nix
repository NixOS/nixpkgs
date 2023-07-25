{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kool";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "kool-dev";
    repo = "kool";
    rev = version;
    hash = "sha256-dMmokaFPzunpCdkJFVc3422SEKZNIOi8nzRB99Gi5Tg=";
  };

  vendorHash = "sha256-8t+OZB9jrlOVHLURPmtz0ent6COEOVMFfObe2LH1jRM=";

  ldflags = [
    "-s"
    "-w"
    "-X=kool-dev/kool/commands.version=${version}"
  ];

  meta = with lib; {
    description = "From local development to the cloud: development workflow made easy";
    homepage = "https://kool.dev";
    changelog = "https://github.com/kool-dev/kool/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
