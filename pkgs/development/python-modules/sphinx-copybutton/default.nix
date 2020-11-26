{ lib
, buildPythonPackage
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-copybutton";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e0461df394515284e3907e3f418a0c60ef6ab6c9a27a800c8552772d0a402a2";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  meta = with lib; {
    description = "Add a copy button to each of your code cells";
    homepage = https://github.com/ExecutableBookProject/sphinx-copybutton;
    license = licenses.mit;
  };
}