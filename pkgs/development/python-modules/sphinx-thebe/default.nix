{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-thebe";
  version = "0.1.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "756f1dd6643f5abb491f8a27b22825b04f47e05c5d214bbb2e6b5d42b621b85e";
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
