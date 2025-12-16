{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  ipython,
  py3nvml,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "watermark";
  version = "2.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = "watermark";
    tag = "v${version}";
    hash = "sha256-vHnXPGHPQz6+y2ZvfmUouL/3JlATGo4fmZ8AIk+bNEU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
    changelog = "https://github.com/rasbt/watermark/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nphilou ];
  };
}
