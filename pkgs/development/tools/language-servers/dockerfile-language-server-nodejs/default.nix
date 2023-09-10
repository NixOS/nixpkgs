{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "dockerfile-language-server-nodejs";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "rcjsuen";
    repo = "dockerfile-language-server-nodejs";
    rev = "v${version}";
    hash = "sha256-uwwwF1eMoSA2C5h56BBllTZW8zRHueNeVwhwtycrNfA=";
  };

  npmDepsHash = "sha256-lI+tkUBR0rmWcU57jU0y7XaMK3JADNU7fcbCxMmz/7s=";

  meta = {
    changelog = "https://github.com/rcjsuen/dockerfile-language-server-nodejs/blob/${src.rev}/CHANGELOG.md";
    description = "A language server for Dockerfiles powered by Node.js, TypeScript, and VSCode technologies";
    homepage = "https://github.com/rcjsuen/dockerfile-language-server-nodejs";
    license = lib.licenses.mit;
    mainProgram = "docker-langserver";
    maintainers = with lib.maintainers; [ rvolosatovs ];
  };
}
