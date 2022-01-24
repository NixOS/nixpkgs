{ lib, buildPythonPackage, fetchFromGitHub, colorama, pytestCheckHook }:

buildPythonPackage rec {
  pname = "simber";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = pname;
    rev = version;
    sha256 = "04dp9b4s7zb166vlacsaypc6iw1p75azqas1wf0flp570qqf3rkx";
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
