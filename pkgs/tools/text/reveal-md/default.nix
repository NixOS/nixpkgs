{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "reveal-md";
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "webpro";
    repo = "reveal-md";
    rev = version;
    hash = "sha256-BlUZsETMdOmnz+OFGQhQ9aLHxIIAZ12X1ipy3u59zxo=";
  };

  npmDepsHash = "sha256-xaDBB16egGi8zThHRrhcN8TVf6Nqkx8fkbxWqvJwJb4=";

  env = {
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = true;
  };

  dontNpmBuild = true;

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    npm run test

    runHook postCheck
  '';

  meta = {
    description = "Get beautiful reveal.js presentations from your Markdown files";
    homepage = "https://github.com/webpro/reveal-md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sagikazarmark ];
  };
}
