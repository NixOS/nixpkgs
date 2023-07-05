{ lib
, buildNpmPackage
, fetchFromGitHub
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

  npmDepsHash = "sha256-WOsStvm7UC2Jnb803mHoJxDUs1I8dDT7HRPdpIXQne8=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

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
