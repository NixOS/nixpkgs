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
  version = "2.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = "watermark";
    tag = "v${version}";
    hash = "sha256-UR4kV6UoZ/JLO19on+qEH+M05QIsT0SXvXJtTMCKuZM=";
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
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "watermark" ];

  meta = with lib; {
    description = "IPython extension for printing date and timestamps, version numbers, and hardware information";
    homepage = "https://github.com/rasbt/watermark";
    changelog = "https://github.com/rasbt/watermark/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nphilou ];
  };
}
