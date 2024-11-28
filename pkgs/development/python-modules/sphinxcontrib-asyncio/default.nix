{
  lib,
  buildPythonPackage,
  fetchPypi,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-asyncio";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mf0m4P5+34ckSnGpnDFv0Mm1CFbCUZrMqSfr50EAci4=";
  };

  propagatedBuildInputs = [ sphinx ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "sphinxcontrib.asyncio" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension to add asyncio-specific markups";
    homepage = "https://github.com/aio-libs/sphinxcontrib-asyncio";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
