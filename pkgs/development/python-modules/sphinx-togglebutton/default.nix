{ lib
, buildPythonPackage
, fetchPypi
, wheel
, sphinx
, docutils
}:

buildPythonPackage rec {
  pname = "sphinx-togglebutton";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qwyLNmQnsB5MiYAtXQeEcsQn+m6dEtUhw0+gRCVZ3Ho=";
  };

  propagatedBuildInputs = [ wheel sphinx docutils ];

  pythonImportsCheck = [ "sphinx_togglebutton" ];

  meta = with lib; {
    description = "Toggle page content and collapse admonitions in Sphinx";
    homepage = "https://github.com/executablebooks/sphinx-togglebutton";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
