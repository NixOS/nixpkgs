{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, six
, future
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "textfsm";
  version = "1.1.2";
  format = "setuptools";


  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cbczg3h2841v1xk2s2xg540c69vsrkwxljm758fyr65kshrzlhm";
  };

  propagatedBuildInputs = [
    six
    future
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python module for parsing semi-structured text into python tables";
    homepage = "https://github.com/google/textfsm";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
