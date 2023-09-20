{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-thebe";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4c8c1542054f991b73fcb28c4cf21697e42aba2f83f22348c1c851b82766583";
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
