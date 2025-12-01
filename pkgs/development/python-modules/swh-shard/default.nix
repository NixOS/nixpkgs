{
  buildPythonPackage,
  click,
  cmake,
  cmph,
  fetchFromGitLab,
  lib,
  ninja,
  pkg-config,
  pybind11,
  pytest-mock,
  pytestCheckHook,
  scikit-build-core,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "swh-shard";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-shard";
    tag = "v${version}";
    hash = "sha256-97oZ+Wa8GmyL2V4CnlSvaTbQZJ+mPbg6uVmWd0oxv1Q=";
  };

  build-system = [
    cmake
    ninja
    pybind11
    scikit-build-core
    setuptools-scm
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    cmph
  ];

  dependencies = [
    click
  ];

  pythonImportsCheck = [ "swh.shard" ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    # import from $out
    rm src/swh/shard/*.py
  '';

  meta = {
    changelog = "https://gitlab.softwareheritage.org/swh/devel/swh-shard/-/tags/v2.2.0";
    description = "Shard File Format for the Software Heritage Object Storage";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-shard";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
