{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ply,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "slimit";
  version = "unstable-2018-08-08";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rspivak";
    repo = "slimit";
    rev = "3533eba9ad5b39f3a015ae6269670022ab310847";
    hash = "sha256-J+8RGENM/+eaTNvoC54XXPP+aWmazlssjnZAY88J/F0=";
  };

  propagatedBuildInputs = [ ply ];

  pythonImportsCheck = [ "slimit" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "SlimIt -  a JavaScript minifier/parser in Python";
    mainProgram = "slimit";
    homepage = "https://github.com/rspivak/slimit";
    changelog = "https://github.com/rspivak/slimit/blob/${src.rev}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
