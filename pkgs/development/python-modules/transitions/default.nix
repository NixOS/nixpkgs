{ lib, buildPythonPackage, fetchFromGitHub
, six, pytestCheckHook, mock, dill, pycodestyle }:

buildPythonPackage rec {
  pname = "transitions";
  version = "0.8.6";

  # test_codestyle.py fails in PyPI sdist
  src = fetchFromGitHub {
    owner = "pytransitions";
    repo = "transitions";
    rev = version;
    sha256 = "1d913hzzyqhdhhbkbvjw65dqkajrw50a4sxhyxk0jlg8pcs7bs7v";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestCheckHook mock dill pycodestyle ];

  meta = with lib; {
    homepage = "https://github.com/pytransitions/transitions";
    description = "A lightweight, object-oriented finite state machine implementation in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
