{
  lib,
  buildPythonPackage,
  fetchPypi,
  meson,
  meson-python,
  cython,
  attrs,
  useful-types,
  pytestCheckHook,
  pillow,
  pytest-regressions,
  dirty-equals,
  setuptools,
}:
let
  pname = "srctools";
  version = "2.6.2";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c+NmrTntpNTEI782aoC4bNpoKpWe4cqSAkxpYS5HH30=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "meson-python == 0.18.0" "meson-python >= 0.18.0"
  '';

  build-system = [
    meson
    meson-python
    cython
  ];

  dependencies = [
    attrs
    useful-types
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pillow
    pytest-regressions
    dirty-equals
    setuptools # required for pythoncapi-compat tests
  ];

  # pythoncpai-comat tests are incompatible with pytest so we run their tests manually
  # see https://github.com/python/pythoncapi-compat/pull/169
  disabledTestPaths = [
    "src/pythoncapi-compat"
  ];
  postCheck = ''
    python3 src/pythoncapi-compat/runtests.py --current
  '';

  pythonImportsCheck = [ "srctools" ];

  meta = {
    description = "Modules for working with Valve's Source Engine file formats";
    homepage = "https://github.com/TeamSpen210/srctools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ different-name ];
  };
}
