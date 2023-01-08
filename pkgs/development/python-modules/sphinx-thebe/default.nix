{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-thebe";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CHZ6WacLlFhpGyujW7b2KkRSlGmUR3rlg5ulPMsKUoc=";
  };

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinx_thebe" ];

  meta = with lib; {
    description = "Integrate interactive code blocks into your documentation with Thebe and Binder";
    homepage = "https://github.com/executablebooks/sphinx-thebe";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
