{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-markdown";
  version = "3.10.0.20251106";
  pyproject = true;

  src = fetchPypi {
    pname = "types_markdown";
    inherit version;
    hash = "sha256-EoNvf8vXIh24uusNOi+CC5UFDQgkv6lmXGe00UShr6E=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "markdown-stubs" ];

  meta = with lib; {
    description = "Typing stubs for Markdown";
    homepage = "https://pypi.org/project/types-Markdown/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
