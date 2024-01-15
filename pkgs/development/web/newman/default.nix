{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "newman";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "postmanlabs";
    repo = "newman";
    rev = "refs/tags/v${version}";
    hash = "sha256-n539UlrKnbvyn1Wt/CL+8vZgjBPku82rV9dhcAvwznk=";
  };

  npmDepsHash = "sha256-rpGec7Vbxa0wPkMRxIngTqTqKVl70TF7pz8BF0iQ3X0=";

  dontNpmBuild = true;

  meta = with lib; {
    homepage = "https://www.getpostman.com";
    description = "A command-line collection runner for Postman";
    changelog = "https://github.com/postmanlabs/newman/releases/tag/v${version}";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.asl20;
  };
}
