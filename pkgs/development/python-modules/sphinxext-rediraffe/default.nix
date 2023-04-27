{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-rediraffe";
  version = "0.2.7";

  format = "wheel";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version format;
    dist = "py3";
    python = "py3";
    pname = "sphinxext_rediraffe";
    hash = "sha256-nkMKUtRAOEf0/7Oo3W38NKn+Q1JTBRMfUu2Jl0Ol/Yw=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  pythonImportsCheck = [
    "sphinxext.rediraffe"
  ];

  meta = with lib; {
    description = "Sphinx extension to redirect files";
    homepage = "https://github.com/wpilibsuite/sphinxext-rediraffe";
    license = licenses.mit;
    maintainers = with maintainers; [ zmitchell ];
  };
}
