{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  aws-rotate-key,
}:

buildGoModule rec {
  pname = "aws-rotate-key";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Fullscreen";
    repo = "aws-rotate-key";
    rev = "v${version}";
    sha256 = "sha256-PZ7+GC4P4bkT+DWOhW70KkhUCUjn4gIG+OKoOBSc/8c=";
  };

  vendorHash = "sha256-Asfbv7avT+L8/WNQ6NS7gFcjA9MiTCu5PzsuA/PT6/k=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = aws-rotate-key;
  };

  meta = with lib; {
    description = "Easily rotate your AWS key";
    homepage = "https://github.com/Fullscreen/aws-rotate-key";
    license = licenses.mit;
    maintainers = [ maintainers.mbode ];
    mainProgram = "aws-rotate-key";
  };
}
