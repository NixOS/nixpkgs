{ lib
, stdenv
, fetchFromGitLab
, libyaml
, testers
, yx
}:
stdenv.mkDerivation rec {
  pname = "yx";
  version = "1.0.0";

  src = fetchFromGitLab {
    owner = "tomalok";
    repo = "yx";
    rev = version;
    sha256 = "sha256-oY61V9xP0DwRooabzi0XtaFsQa2GwYbuvxfERXQtYcA=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  strictDeps = true;

  buildInputs = [ libyaml ];

  doCheck = true;

  passthru.tests.version = testers.testVersion {
    package = yx;
    command = "${meta.mainProgram} -v";
    version = "v${yx.version}";
  };

  meta = with lib; {
    description = "YAML Data Extraction Tool";
    homepage = "https://gitlab.com/tomalok/yx";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ twz123 ];
    mainProgram = "yx";
  };
}
