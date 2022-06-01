{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sdds";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pylhc";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-l9j+YJ5VNMzL6JW59kq0hQS7XIj53UxW5bNnfdURz/o=";
  };

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "sdds" ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python 3 package to handle SDDS files";
    homepage = "https://pylhc.github.io/sdds/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
