{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "reveal-md";
  version = "5.5.2";

  src = fetchFromGitHub {
    owner = "webpro";
    repo = "reveal-md";
    rev = version;
    hash = "sha256-Uge7N6z9O1wc+nW/0k5qz+CPYbYgr7u2mulH75pXvHY=";
  };

  npmDepsHash = "sha256-+gzur0pAmZe4nrDxNQwjFn/hM9TvZEd6JzLOnJLhNtg=";

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
    mainProgram = "reveal-md";
    homepage = "https://github.com/webpro/reveal-md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sagikazarmark ];
  };
}
