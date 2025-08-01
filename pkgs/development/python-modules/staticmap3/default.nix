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
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SamR1";
    repo = "staticmap";
    tag = "v${version}";
    hash = "sha256-SMy4yxHA9Z3BFW6kX8vC7WfsmuZMNqocJ9+dJB6zwSs=";
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
