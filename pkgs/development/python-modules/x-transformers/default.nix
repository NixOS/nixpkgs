{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  einops,
  torch,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "x-transformers";
  version = "1.32.2";
  pyproject = true;

  src = fetchPypi {
    pname = "x_transformers";
    inherit version;
    hash = "sha256-NUIlJ+N2/6kz3rI0oc7bfYVWnMkZhvfljQ6zSwBPkWo=";
  };

  postPatch = ''
    sed -i '/setup_requires=\[/,/\],/d' setup.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    einops
    torch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "x_transformers" ];

  meta = {
    description = "Concise but fully-featured transformer";
    longDescription = ''
      A simple but complete full-attention transformer with a set of promising experimental features from various papers
    '';
    homepage = "https://github.com/lucidrains/x-transformers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ByteSudoer ];
  };
}
