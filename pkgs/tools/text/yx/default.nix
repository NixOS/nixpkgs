{ lib, stdenv, fetchFromGitLab, libyaml }:
stdenv.mkDerivation rec {
  pname = "yx";
  version = "1.0.0";

  src = fetchFromGitLab {
    owner = "tomalok";
    repo = pname;
    rev = version;
    sha256 = "sha256-oY61V9xP0DwRooabzi0XtaFsQa2GwYbuvxfERXQtYcA=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  strictDeps = true;

  buildInputs = [ libyaml ];

  doCheck = true;

  meta = with lib; {
    description = "YAML Data Extraction Tool";
    homepage = "https://gitlab.com/tomalok/yx";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ twz123 ];
    mainProgram = "yx";
  };
}
