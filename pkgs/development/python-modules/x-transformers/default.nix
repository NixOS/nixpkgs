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
  version = "1.44.4";
  pyproject = true;

  src = fetchPypi {
    pname = "x_transformers";
    inherit version;
    hash = "sha256-m6Vx/D4rTur4n/DqWEAjD7jK43wEgwhdrQi8+ndsN+E=";
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
