{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "newman";
  version = "5.3.2";

  src = fetchFromGitHub {
    owner = "postmanlabs";
    repo = "newman";
    rev = "refs/tags/v${version}";
    hash = "sha256-j5YS9Zbk9b3K4+0sGzqtCgEsR+S5nGPf/rebeGzsscA=";
  };

  npmDepsHash = "sha256-FwVmesHtzTZKsTCIfZiRPb1zf7q5LqABAZOh8gXB9qw=";

  dontNpmBuild = true;

  meta = with lib; {
    homepage = "https://www.getpostman.com";
    description = "A command-line collection runner for Postman";
    changelog = "https://github.com/postmanlabs/newman/releases/tag/v${version}";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.asl20;
  };
}
