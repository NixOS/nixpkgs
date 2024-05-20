{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, python3
, xcbuild
}:

buildNpmPackage rec {
  pname = "firebase-tools";
  version = "13.9.0";

  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-tools";
    rev = "v${version}";
    hash = "sha256-a/rtEDodVL0QCqxEhklDwiTSMFI1hKPrkbtsJH0Au64=";
  };

  npmDepsHash = "sha256-z7h+Jh3KuMkxn5gUDHYlU1+UyABHdLh2IFJiu6wFkhU=";

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
