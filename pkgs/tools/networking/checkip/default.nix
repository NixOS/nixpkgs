{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "checkip";
  version = "0.46.2";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5GOVn95gaiRPoQvfeBG+zxSISwgMk0L2vexcQtPC/dw=";
  };

  vendorHash = "sha256-awqaDEdWILm8RcQ8hrtJFMTJQA5TzGZhiBTMfexmtA0=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    changelog = "https://github.com/jreisinger/checkip/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "checkip";
  };
}
