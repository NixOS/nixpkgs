{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "restic-rest-server";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "rest-server";
    rev = "v${version}";
    hash = "sha256-o55y+g9XklKghVK1c6MTRI8EHLplTv5YKUWGRyyvmtk=";
  };

  vendorHash = "sha256-MBkh61vFogf0su/mP3b2J8t/LTtfVzLlpa9MSzAq6Tw=";

  passthru.tests.restic = nixosTests.restic-rest-server;

  meta = with lib; {
    changelog = "https://github.com/restic/rest-server/blob/${src.rev}/CHANGELOG.md";
    description = "High performance HTTP server that implements restic's REST backend API";
    mainProgram = "rest-server";
    homepage = "https://github.com/restic/rest-server";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dotlambda ];
  };
}
