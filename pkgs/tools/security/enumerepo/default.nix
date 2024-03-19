{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "enumerepo";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "trickest";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-PWWx6b+fttxKxMtuHAYPTeEsta0E6+IQ1DSKO6c7Jdc=";
  };

  vendorHash = "sha256-Dt3QS1Rm/20Yitgg4zbBcWQXV8mTlpNbzc/k4DaTuQc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to list all public repositories for (valid) GitHub usernames";
    mainProgram = "enumerepo";
    homepage = "https://github.com/trickest/enumerepo";
    changelog = "https://github.com/trickest/enumerepo/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
