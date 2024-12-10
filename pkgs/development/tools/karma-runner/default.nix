{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "karma";
  version = "6.4.2";

  src = fetchFromGitHub {
    owner = "karma-runner";
    repo = "karma";
    rev = "v${version}";
    hash = "sha256-v6IiLz65NS8GwM/FPqRxR5qcFDDu7EqloR0SIensdDI=";
  };

  patches = [
    ./fix-package-lock.patch
  ];

  npmDepsHash = "sha256-nX4/96WdPEDZ6DASp+AOBbBbHyq+p2zIh2dZUbtmIPI=";

  env.PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = true;

  meta = {
    description = "Spectacular Test Runner for JavaScript";
    homepage = "http://karma-runner.github.io/";
    license = lib.licenses.mit;
    mainProgram = "karma";
    maintainers = with lib.maintainers; [ ];
  };
}
