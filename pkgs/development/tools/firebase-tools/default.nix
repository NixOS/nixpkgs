{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, python3
, xcbuild
}:

buildNpmPackage rec {
  pname = "firebase-tools";
  version = "13.5.0";

  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-tools";
    rev = "v${version}";
    hash = "sha256-9xgXPQa+a9nR5e1xbNnkZb+gPrK+5nWZS/Dhzva6DVQ=";
  };

  npmDepsHash = "sha256-wuuZfqP39fxvkNc9dXK9iE2x2QHOQUTi/pWu4ZRuYgE=";

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';

  nativeBuildInputs = [
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild
  ];

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  meta = {
    changelog = "https://github.com/firebase/firebase-tools/blob/${src.rev}/CHANGELOG.md";
    description = "Manage, and deploy your Firebase project from the command line";
    homepage = "https://github.com/firebase/firebase-tools";
    license = lib.licenses.mit;
    mainProgram = "firebase";
    maintainers = with lib.maintainers; [ ];
  };
}
