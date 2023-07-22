{ lib
, fetchFromGitHub
, python3
, bc
, jq
}:

let
  pname = "pyp";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "hauntsaninja";
    repo = "pyp";
    rev = "v${version}";
    hash = "sha256-A1Ip41kxH17BakHEWEuymfa24eBEl5FIHAWL+iZFM4I=";
  };
in
python3.pkgs.buildPythonApplication {
  inherit pname version src;

  format = "pyproject";

  nativeBuildInputs = [
    python3.pkgs.flit-core
  ];

  nativeCheckInputs = [
    python3.pkgs.pytest
    bc
    jq
  ];

  checkPhase = ''
    runHook preCheck

    PATH=$out/bin:$PATH pytest

    runHook postCheck
  '';

  meta = {
    homepage = "https://github.com/hauntsaninja/pyp";
    description = "Easily run Python at the shell";
    changelog = "https://github.com/hauntsaninja/pyp/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
