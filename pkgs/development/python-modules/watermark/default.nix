{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  ipython,
  py3nvml,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "watermark";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = "watermark";
    tag = "v${version}";
    hash = "sha256-WeHMzSt4HUJZ9M9/Yu1h3VB5GuD/I9x+v6VyUhsmFhU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ipython
    importlib-metadata
  ];

  optional-dependencies = {
    gpu = [ py3nvml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "watermark" ];

  meta = {
    description = "IPython extension for printing date and timestamps, version numbers, and hardware information";
    homepage = "https://github.com/rasbt/watermark";
    changelog = "https://github.com/rasbt/watermark/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nphilou ];
  };
}
