{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  guidata,
  hdf5plugin,
  plotpy,
  psutil,
  sigima,

  # optional-dependencies
  pyqt5,

  # tests
  pytestCheckHook,
  qt6,
  pyqt6,
}:

buildPythonPackage (finalAttrs: {
  pname = "sigimax";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DataLab-Platform";
    repo = "SigimaX";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bxdszggu4Zlnklh21R3pTQr4s93b/O52wGgX6xRfuhc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    guidata
    hdf5plugin
    plotpy
    psutil
    sigima
  ];

  optional-dependencies = {
    qt = [
      pyqt5
    ];
  };

  pythonImportsCheck = [
    "sigimax"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyqt6
  ];

  preCheck = ''
    export QT_PLUGIN_PATH="${lib.getBin qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}:${qt6.qtsvg}/${qt6.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM=offscreen
  '';

  meta = {
    description = "Reusable GUI components and application utilities for DataLab";
    homepage = "https://github.com/DataLab-Platform/SigimaX";
    changelog = "https://github.com/DataLab-Platform/SigimaX/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.bsd3;
    teams = with lib.teams; [ ngi ];
  };
})
