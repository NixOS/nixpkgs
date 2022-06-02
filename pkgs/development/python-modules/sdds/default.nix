{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sdds";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pylhc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JcxcF0tDigZz3upzE7rPDynCH45dnLk/zpS0a2dOwRU=";
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
