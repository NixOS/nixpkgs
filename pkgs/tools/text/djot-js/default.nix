{ lib
, buildNpmPackage
, fetchFromGitHub
, fetchpatch
, installShellFiles
}:

buildNpmPackage rec {
  pname = "djot-js";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "jgm";
    repo = "djot.js";
    rev = "@djot/djot@${version}";
    hash = "sha256-W/ZQXJXvFEIgj5PeI+jvw4nIkNP4qa1NyQCOv0unIuA=";
  };

  npmDepsHash = "sha256-x/Oc39S6XwZ/ZsS/lmMU9OkHLlKuUxETYmD8pdHAIg8=";

  patches = [
    # djot.js v0.2.3 doesn't include package-lock.json in the repository
    # remove at next release
    (fetchpatch {
      name = "add-package-lock-json-and-yarn-lock-to-repository.patch";
      url = "https://github.com/jgm/djot.js/commit/15ed52755b2968932d4a9a80805b9ea6183fe539.patch";
      hash = "sha256-saNmU7z4IOOG3ptXMFDSNci5uu0d2GiVZ/FAlaNccTc=";
    })
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage doc/djot.1
  '';

  meta = with lib; {
    description = "JavaScript implementation of djot";
    homepage = "https://github.com/jgm/djot.js";
    changelog = "https://github.com/jgm/djot.js/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "djot";
  };
}
