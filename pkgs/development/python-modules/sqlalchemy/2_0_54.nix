{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  setuptools,
  cython,
  greenlet,
  typing-extensions,
  mock,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sqlalchemy";
  version = "2.0.54";
  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uqhSHo7p8k5138eqq8CAIOVR7w1I18PjU29c3fJ3WGs=";
  };

  postPatch = ''
    sed -i '/tag_build = dev/d' setup.cfg
  '';

  build-system = [ setuptools ] ++ lib.optionals (!isPyPy) [ cython ];

  dependencies = [
    greenlet
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    mock
  ];

  disabledTestPaths = [
    # typing correctness, not interesting
    "test/ext/mypy"
    "test/typing"
    # slow and high memory usage, not interesting
    "test/aaa_profiling"
  ];

  pythonImportsCheck = [ "sqlalchemy" ];

  meta = {
    description = "Python SQL toolkit and Object Relational Mapper";
    homepage = "https://www.sqlalchemy.org/";
    license = lib.licenses.mit;
  };
}
