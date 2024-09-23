{ lib, buildGoModule, fetchgit, nixosTests }:

buildGoModule rec {
  pname = "molly-brown";
  version = "unstable-2023-02-10";

  src = fetchgit {
    url = "https://tildegit.org/solderpunk/molly-brown.git";
    rev = "56d8dde14abc90b784b7844602f12100af9756e0";
    hash = "sha256-kfopRyCrDaiVjKYseyWacIT9MJ8PzB8LAs6YMgYqCrs=";
  };

  vendorHash = "sha256-czfHnXS9tf5vQQNXhWH7DStmhsorSc4Di/yZuv4LHRk=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.basic = nixosTests.molly-brown;

  meta = with lib; {
    description = "Full-featured Gemini server";
    mainProgram = "molly-brown";
    homepage = "https://tildegit.org/solderpunk/molly-brown";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.bsd2;
  };
}
