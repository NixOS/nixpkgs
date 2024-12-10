{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "restic-rest-server";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "rest-server";
    rev = "v${version}";
    hash = "sha256-0zmUI7LUKVXUdPsNxY7RQxbsAraY0GrTMAS3kORIU6I=";
  };

  vendorHash = "sha256-tD5ffIYULMBqu99l1xCL0RnLB9zNpwNPs1qVFqezUc8=";

  passthru.tests.restic = nixosTests.restic-rest-server;

  meta = with lib; {
    changelog = "https://github.com/restic/rest-server/blob/${src.rev}/CHANGELOG.md";
    description = "A high performance HTTP server that implements restic's REST backend API";
    mainProgram = "rest-server";
    homepage = "https://github.com/restic/rest-server";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dotlambda ];
  };
}
