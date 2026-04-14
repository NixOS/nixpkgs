{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "texsoup";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alvinwan";
    repo = "TexSoup";
    tag = version;
    hash = "sha256-CKUDDq+97kktQnsdwOkwLILdsE7CkQMxId30fbWX90c=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "TexSoup" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Fault-tolerant Python3 package for searching, navigating, and modifying LaTeX documents";
    homepage = "https://github.com/alvinwan/TexSoup";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
