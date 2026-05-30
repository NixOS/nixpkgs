{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cachecontrol,
  filelock,
  mypy,
  pillow,
  poetry-core,
  requests,
  ruff,
  types-requests,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "staticmap3";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SamR1";
    repo = "staticmap";
    tag = "v${version}";
    hash = "sha256-SV9D8wYph82IaITXxraC+8YO+taeEc6g/CPjFITzV5Q=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    cachecontrol
    requests
    pillow
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  optional-dependencies = {
    filecache = [ filelock ];
    dev = [
      mypy
      ruff
      types-requests
    ];
  };

  pythonImportsCheck = [ "staticmap3" ];

  meta = {
    description = "Small, python-based library for creating map images with lines and markers";
    homepage = "https://github.com/SamR1/staticmap";
    changelog = "https://github.com/SamR1/staticmap/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tebriel ];
  };
}
