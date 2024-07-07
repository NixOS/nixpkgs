{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "markdownlint-cli2";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "DavidAnson";
    repo = "markdownlint-cli2";
    rev = "v${version}";
    hash = "sha256-qtdR7Rhz+HLZJX82OrN+twOsvFOv99e4BBDVV1UayPI=";
  };

  npmDepsHash = "sha256-Fx0lDcvzLRVSAX0apKmu1CBfnGmGQR9FQEdhHUtue/c=";

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/DavidAnson/markdownlint-cli2/blob/${src.rev}/CHANGELOG.md";
    description = "Fast, flexible, configuration-based command-line interface for linting Markdown/CommonMark files with the markdownlint library";
    homepage = "https://github.com/DavidAnson/markdownlint-cli2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
