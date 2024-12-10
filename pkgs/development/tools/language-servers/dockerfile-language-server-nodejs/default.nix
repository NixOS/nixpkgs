{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "dockerfile-language-server-nodejs";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "rcjsuen";
    repo = "dockerfile-language-server-nodejs";
    rev = "v${version}";
    hash = "sha256-xhb540hXATfSo+O+BAYt4VWOa6QHLzKHoi0qKrdBVjw=";
  };

  preBuild = ''
    npm run prepublishOnly
  '';

  npmDepsHash = "sha256-+u4AM6wzVMhfQisw/kcwg4u0rzrbbQeIIk6qBXUM+5I=";

  meta = {
    changelog = "https://github.com/rcjsuen/dockerfile-language-server-nodejs/blob/${src.rev}/CHANGELOG.md";
    description = "A language server for Dockerfiles powered by Node.js, TypeScript, and VSCode technologies";
    homepage = "https://github.com/rcjsuen/dockerfile-language-server-nodejs";
    license = lib.licenses.mit;
    mainProgram = "docker-langserver";
    maintainers = with lib.maintainers; [
      rvolosatovs
      net-mist
    ];
  };
}
