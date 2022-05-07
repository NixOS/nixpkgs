{ lib
, buildPythonPackage
, construct
, fetchFromGitHub
, isPy3k
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "snapcast";
  version = "2.2.0";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "happyleavesaoc";
    repo = "python-snapcast";
    rev = "refs/tags/${version}";
    sha256 = "sha256-H41X5bfRRu+uE7eUsmUkONm6hugNs43+O7MvVPH0e+8=";
  };

  propagatedBuildInputs = [
    construct
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "snapcast" ];

  meta = with lib; {
    description = "Control Snapcast, a multi-room synchronous audio solution";
    homepage = "https://github.com/happyleavesaoc/python-snapcast/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
