{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "types-markdown";
  version = "3.5.0.20240106";
  pyproject = true;

  src = fetchPypi {
    pname = "types-Markdown";
    inherit version;
    hash = "sha256-vkfTXL5h1Fi9F67BJ/HaIzzW7Zb6mhMccQN4pOiFcDA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "markdown-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for Markdown";
    homepage = "https://pypi.org/project/types-Markdown/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
