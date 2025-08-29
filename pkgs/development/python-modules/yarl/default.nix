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
  pytest-codspeed,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "yarl";
  version = "1.21.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "yarl";
    tag = "v${version}";
    hash = "sha256-YN2Gn/wokwbBbVcKvqNNJZ8eZKxwwdKbA84kPsx1Dg0=";
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
    pytest-codspeed
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
  ];

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "yarl" ];

  meta = with lib; {
    changelog = "https://github.com/aio-libs/yarl/blob/v${version}/CHANGES.rst";
    description = "Yet another URL library";
    homepage = "https://github.com/aio-libs/yarl";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
