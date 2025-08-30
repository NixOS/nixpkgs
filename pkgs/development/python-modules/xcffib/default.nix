{
  lib,
  stdenv,
  buildPythonPackage,
  cffi,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  xorg,
}:

buildPythonPackage rec {
  pname = "xcffib";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K6xgY2lnVOiHHC9AcwR7Uz792Cx33fhnYgEWcJfMUlM=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    # Hardcode cairo library path
    substituteInPlace xcffib/__init__.py \
      --replace-fail "dlopen(soname)" 'dlopen("${xorg.libxcb}/lib/" + soname)'
  '';

  dependencies = [ cffi ];

  nativeCheckInputs = [
    pytestCheckHook
    xorg.xeyes
    xorg.xvfb
  ];

  preCheck = ''
    # import from $out
    rm -r xcffib
  '';

  disabledTests = lib.optionals stdenv.buildPlatform.isDarwin [
    # AssertionError: assert 'base' == 'evdev'
    # test/test_xkb.py:18: AssertionError
    "test_query_rules_names"
  ];

  pythonImportsCheck = [ "xcffib" ];

  # Tests use xvfb
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Drop in replacement for xpyb, an XCB python binding";
    homepage = "https://github.com/tych0/xcffib";
    changelog = "https://github.com/tych0/xcffib/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    maintainers = with lib.maintainers; [ kamilchm ];
  };
}
