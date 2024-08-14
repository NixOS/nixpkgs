{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-markdown";
  version = "3.6.0.20240316";
  pyproject = true;

  src = fetchPypi {
    pname = "types-Markdown";
    inherit version;
    hash = "sha256-3p+4SGC1W2R7FwyldolfzKYbk0puzcZcMZMsZ5W0QLg=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "markdown-stubs" ];

  meta = with lib; {
    description = "Typing stubs for Markdown";
    homepage = "https://pypi.org/project/types-Markdown/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
