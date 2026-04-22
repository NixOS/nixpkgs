{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  iniconfig,
  numpy,
  psutil,
  pytest-console-scripts,
  pytestCheckHook,
  pyvips,
  scipy,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "scooby";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "banesullivan";
    repo = "scooby";
    tag = "v${version}";
    hash = "sha256-Wg/cM6G75x3VVZEwdAhfjf6PkefUWLqX/p9GPP2mRls=";
  };

  build-system = [ setuptools-scm ];

  optional-dependencies = {
    cpu = [
      psutil
      # mkl
    ];
  };

  nativeCheckInputs = [
    beautifulsoup4
    iniconfig
    numpy
    pytest-console-scripts
    pytestCheckHook
    pyvips
    scipy
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [ "scooby" ];

  disabledTests = [
    # Tests have additions requirements (e.g., time and module)
    "test_get_version"
    "test_tracking"
    "test_import_os_error"
    "test_import_time"
    # TypeError: expected str, bytes or os.PathLike object, not list
    "test_cli"
    # Fails to find iniconfig in environment
    "test_auto_report"
  ];

  meta = {
    changelog = "https://github.com/banesullivan/scooby/releases/tag/v${version}";
    description = "Lightweight tool for reporting Python package versions and hardware resources";
    mainProgram = "scooby";
    homepage = "https://github.com/banesullivan/scooby";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
