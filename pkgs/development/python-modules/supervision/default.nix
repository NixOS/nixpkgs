{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  defusedxml,
  matplotlib,
  numpy,
  opencv-python,
  pillow,
  pyyaml,
  requests,
  scipy,
  tqdm,

  # optional-dependencies
  pandas,

  # nativeCheckInputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "supervision";
  version = "0.26.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roboflow";
    repo = "supervision";
    tag = version;
    hash = "sha256-FDVNPMviONB6JlCWgEyq1gf6dWT2MOGQ+fVtnreNv7g=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    defusedxml
    matplotlib
    numpy
    opencv-python
    pillow
    pyyaml
    requests
    scipy
    tqdm
  ];

  optional-dependencies = {
    metrics = [
      pandas
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  preInstallCheck = ''
    # silence matplotlib warning
    export MPLCONFIGDIR=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "supervision"
  ];

  meta = {
    description = "Reusable computer vision tools";
    homepage = "https://github.com/roboflow/supervision";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
