{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-html5lib";
  version = "1.1.11.20241018";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mAQlVf942eOlHHfJGLEEGsu362xAVAjYqeFQ/1vsyvo=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "html5lib-stubs" ];

  meta = with lib; {
    description = "Typing stubs for html5lib";
    homepage = "https://pypi.org/project/types-html5lib/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
