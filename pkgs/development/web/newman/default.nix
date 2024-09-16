{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "newman";
  version = "6.1.3";

  src = fetchFromGitHub {
    owner = "postmanlabs";
    repo = "newman";
    rev = "refs/tags/v${version}";
    hash = "sha256-I9gpVwrrug1Ygi0UuBIeq16Nyn8rsaDkMDtpxBYJOuY=";
  };

  npmDepsHash = "sha256-StNu5NHGzivl3+GMBWkbxvsRJ/dYuS0dze+8/i7q9qg=";

  dontNpmBuild = true;

  meta = with lib; {
    homepage = "https://www.getpostman.com";
    description = "Command-line collection runner for Postman";
    mainProgram = "newman";
    changelog = "https://github.com/postmanlabs/newman/releases/tag/v${version}";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.asl20;
  };
}
