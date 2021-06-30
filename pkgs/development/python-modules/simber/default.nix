{ lib, buildPythonPackage, fetchFromGitHub, colorama, pytestCheckHook }:

buildPythonPackage rec {
  pname = "simber";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = pname;
    rev = version;
    sha256 = "0ksc2m61j5ijj0sq6kkc0hhkmfy9f51h9z3cl2sf8g6wbr9vc47h";
  };

  propagatedBuildInputs = [ colorama ];

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "simber" ];

  meta = with lib; {
    description = "Simple, minimal and powerful logger for Python";
    homepage = "https://github.com/deepjyoti30/simber";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
