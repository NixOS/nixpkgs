{ lib
, python3
, fetchFromGitHub
}:
let
  inherit (python3.pkgs) buildPythonApplication pytestCheckHook;
in

buildPythonApplication rec {
  pname = "codequestion";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "neuml";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QkkSLtVxkPZHyuVaXhrf9zZIqV8sXb8TFUKCH8bJ82A=";
  };

  propagatedBuildInputs = [ ];


  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/neuml/codequestion";
    description = "Semantic search for developers";
    license = licenses.asl20;
    maintainers = with maintainers; [ ehllie ];
  };
}
