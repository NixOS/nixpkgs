{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "reveal-md";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "webpro";
    repo = "reveal-md";
    rev = version;
    hash = "sha256-MPNxQpof36XHg3Zl7fHkyCXnoDOcRvMiMiPH29GEWqE=";
  };

  npmDepsHash = "sha256-535tauun6ysPDC096ttPpvJZ+RSZ75aY8mVKj8mnMJI=";

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
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
    mainProgram = "reveal-md";
    homepage = "https://github.com/webpro/reveal-md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sagikazarmark ];
  };
}
