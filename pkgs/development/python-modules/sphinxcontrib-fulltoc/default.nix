{ lib
, buildPythonPackage
, fetchPypi
, setuptoolsLegacyNamespaceHook
, sphinx
, pbr
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-fulltoc";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yEXWL8Rn8xNdRUPp8Q4T75GFJoO9HJD9GdB/nTZ1fNk=";
  };

  nativeBuildInputs = [
    pbr
    setuptoolsLegacyNamespaceHook
  ];

  propagatedBuildInputs = [ sphinx ];

  # There are no unit tests
  doCheck = false;

  # Ensure package importing works
  pythonImportsCheck = [ "sphinxcontrib.fulltoc" ];

  meta = with lib; {
    description = "Include a full table of contents in your Sphinx HTML sidebar";
    homepage = "https://sphinxcontrib-fulltoc.readthedocs.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ jluttine ];
  };
}
