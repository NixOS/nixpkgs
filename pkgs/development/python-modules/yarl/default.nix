{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  expandvars,
  setuptools,
  idna,
  multidict,
  propcache,
  hypothesis,
  pydantic,
  pytest-codspeed,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "yarl";
  version = "1.24.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "yarl";
    tag = "v${version}";
    hash = "sha256-GEe2GDXmqsQgWB0UxPZVMdSco3j2JYHg9BU9M6oqynw=";
  };

  build-system = [
    cython
    expandvars
    setuptools
  ];

  dependencies = [
    idna
    multidict
    propcache
  ];

  preCheck = ''
    # don't import yarl from ./ so the C extension is available
    pushd tests
  '';

  nativeCheckInputs = [
    hypothesis
    pydantic
    pytest-codspeed
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
  ];

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "yarl" ];

  meta = {
    changelog = "https://github.com/aio-libs/yarl/blob/${src.tag}/CHANGES.rst";
    description = "Yet another URL library";
    homepage = "https://github.com/aio-libs/yarl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
