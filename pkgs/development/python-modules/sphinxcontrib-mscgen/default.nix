{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  sphinx,
  mscgen,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-mscgen";
  version = "0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AXfSWRq3CepT/jNOgHxiYT7vkdKZejPu/LeUqxZ8T5A=";
  };

  propagatedBuildInputs = [
    mscgen
    sphinx
  ];

  # There are no unit tests
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.mscgen" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension using mscgen to render diagrams";
    homepage = "https://github.com/sphinx-contrib/mscgen";
    license = licenses.bola11;
    maintainers = [ ];
  };
}
