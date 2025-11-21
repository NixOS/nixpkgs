{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  setuptools-scm,
  colorama,
  ghdl,
}:
buildPythonPackage rec {
  pname = "vunit-hdl";
  version = "4.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "vunit_hdl";
    inherit version;
    hash = "sha256-ol+5kbq9LqhRlm4NvcX02PZJqz5lDjASmDsp/V0Y8i0=";
  };

  patches = [ ./setuptools-relax-deps.patch ];

  build-system = [
    setuptools-scm
  ];

  dependencies = [ colorama ];

  nativeCheckInputs = [
    pytestCheckHook
    ghdl
  ];

  disabledTestPaths = [
    # non-functional tests
    "tests/lint"
    # hard-coded test regexes against outdated `ghdl --version` output, "mcode backend" now "mcode JIT backend"
    "tests/acceptance"
  ];

  pythonImportsCheck = [ "vunit" ];

  meta = with lib; {
    homepage = "http://vunit.github.io/";
    description = "Unit testing framework for VHDL/SystemVerilog";
    changelog = "https://github.com/VUnit/vunit/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jleightcap ];
  };
}
