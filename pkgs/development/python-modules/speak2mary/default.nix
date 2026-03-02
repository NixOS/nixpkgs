{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "speak2mary";
  version = "1.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5W2E/leT/IiXFVXD+LSPE99zGlz+yKm5XCv830rt8O0=";
  };

  build-system = [ setuptools ];

  # Tests require a running MaryTTS server
  doCheck = false;

  pythonImportsCheck = [ "speak2mary" ];

  meta = {
    description = "Python wrapper for a running MaryTTS server";
    homepage = "https://github.com/Poeschl/speak2mary";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
