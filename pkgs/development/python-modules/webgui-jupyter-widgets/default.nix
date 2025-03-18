{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jupyter-packaging,
  jupyterlab,
  notebook,
  setuptools,
  packaging,
  yarnConfigHook,
  fetchYarnDeps,
  nodejs,
  numpy,
  jupyterlab-widgets,
  ipywidgets,
}:

buildPythonPackage rec {
  pname = "webgui-jupyter-widgets";
  version = "0.2.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CERBSim";
    repo = "webgui_jupyter_widgets";
    rev = "4d5b097a69c3a629a09871de340a853cd499bd30";
    hash = "sha256-KcKDIfPGVyaByTMuOqXOCVIGfQpT5HHiJY+CAZpKwKU=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "jupyterlab==3.*" "jupyterlab>=3.0" \
      --replace-fail "jupyter_packaging==0.7.9" "jupyter_packaging>=0.7.9"
    substituteInPlace setup.py \
      --replace-fail "install_npm" "#install_npm"
  '';

  webguiYarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/webgui/yarn.lock";
    hash = "sha256-dW5zbNOpawF64LAaHly02Xgsa8C4seFIXBJLwd8BTVo=";
  };

  preConfigure = ''
    echo "building submodule webgui"
    cd webgui
    yarnOfflineCache=$webguiYarnOfflineCache runHook yarnConfigHook
    yarn --offline run build
    cd -
  '';

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-d6s8U7seUO1HWttxJV+1SosnAI6D4xlS5XSObOk3ezo=";
  };

  preBuild = ''
    yarn --offline run build:prod
  '';

  build-system = [
    nodejs
    setuptools
    notebook
    jupyter-packaging
    yarnConfigHook
  ];

  dependencies = [
    numpy
    jupyterlab
    packaging
    jupyterlab-widgets
    ipywidgets
  ];

  pythonImportsCheck = [ "webgui_jupyter_widgets" ];

  meta = {
    description = "Jupyter widgetds library for webgui js visualization library";
    homepage = "https://github.com/CERBSim/webgui_jupyter_widgets";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
