{ lib
, stdenv
, python3
, fetchPypi
, nix-update-script
, runtimeShell
}:

with python3.pkgs;
buildPythonApplication rec {
  pname = "pdm";
  version = "2.9.3";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CxGVtR6WMLWgsGPyffywEgy26ihPGkzZdaOibwhW0lM=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    blinker
    certifi
    cachecontrol
    findpython
    installer
    packaging
    platformdirs
    pyproject-hooks
    python-dotenv
    requests-toolbelt
    resolvelib
    rich
    shellingham
    tomlkit
    unearth
    virtualenv
  ]
  ++ cachecontrol.optional-dependencies.filecache
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ]
  ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-rerunfailures
    pytest-xdist
    pytest-httpserver
  ] ++ lib.optional stdenv.isLinux first;

  pytestFlagsArray = [
    "-m 'not network'"
  ];

  preCheck = ''
    export HOME=$TMPDIR
    substituteInPlace tests/cli/test_run.py \
      --replace "/bin/bash" "${runtimeShell}"
  '';

  disabledTests = [
    # fails to locate setuptools (maybe upstream bug)
    "test_convert_setup_py_project"
    # pythonfinder isn't aware of nix's python infrastructure
    "test_use_wrapper_python"
    "test_use_invalid_wrapper_python"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://pdm.fming.dev";
    changelog = "https://github.com/pdm-project/pdm/releases/tag/${version}";
    description = "A modern Python package manager with PEP 582 support";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
