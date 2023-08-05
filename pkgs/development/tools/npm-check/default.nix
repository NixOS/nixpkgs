{ buildNpmPackage
, fetchFromGitHub
, lib
}:

buildNpmPackage rec {
  pname = "npm-check";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "dylang";
    repo = "npm-check";
    rev = "v${version}";
    hash = "sha256-F7bMvGqOxJzoaw25VR6D90UNwT8HxZ4PZhhQEvQFDn4=";
  };

  npmDepsHash = "sha256-KRLgLWikcCWMF8/cOxThom6DHE9ar6WO/9HtosJQnLE=";

  npmFlags = [ "--legacy-peer-deps" ];

  dontNpmBuild = true;

  meta = with lib; {
    description = "Check for outdated, incorrect, and unused dependencies";
    homepage = "https://github.com/dylang/npm-check";
    changelog = "https://github.com/dylang/npm-check/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.thomasjm ];
  };
}
