{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  colorcet,
  hypothesis,
  multipledispatch,
  numba,
  numpy,
  pandas,
  param,
  pyct,
  requests,
  scipy,
  toolz,
  packaging,
  xarray,
  pytestCheckHook,
  pytest-xdist,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "datashader";
  version = "0.19.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = "datashader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jP6e7YmLyg3wd8QQZ4Vzr7vRFsRmttjIrEgIFqd6+hQ=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    colorcet
    multipledispatch
    numba
    numpy
    pandas
    param
    pyct
    requests
    scipy
    toolz
    packaging
    xarray
  ];

  pytestFlags = [
    "-W ignore::pytest.PytestRemovedIn10Warning"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    writableTmpDirAsHomeHook
    hypothesis
  ];

  disabledTestPaths = [
    "scripts/download_data.py"
  ];

  pythonImportsCheck = [ "datashader" ];

  meta = {
    description = "Data visualization toolchain based on aggregating into a grid";
    mainProgram = "datashader";
    homepage = "https://datashader.org";
    changelog = "https://github.com/holoviz/datashader/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      nickcao
      locnide
    ];
  };
})
