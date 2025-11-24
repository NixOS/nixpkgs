{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-awscrt";
  version = "0.29.0";
  pyproject = true;

  src = fetchPypi {
    pname = "types_awscrt";
    inherit version;
    hash = "sha256-f4EECEYJXLr2Tmt5BAQ0dQ1PL0h1RNd0i3eMNJ05NRA=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "awscrt-stubs" ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Type annotations and code completion for awscrt";
    homepage = "https://github.com/youtype/types-awscrt";
    changelog = "https://github.com/youtype/types-awscrt/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
