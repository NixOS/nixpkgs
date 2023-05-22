{ lib
, buildPythonPackage
, colorama
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "vunit";
  version = "4.7.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "vunit_hdl";
    inherit version;
    sha256 = "sha256-ol+5kbq9LqhRlm4NvcX02PZJqz5lDjASmDsp/V0Y8i0=";
  };

  propagatedBuildInputs = [ colorama ];

  pythonImportsCheck = [ "vunit" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/lint"
    "tests/acceptance"
  ];

  meta = with lib; {
    changelog = "https://github.com/VUnit/vunit/releases/tag/${version}";
    description = "A unit testing framework for VHDL/SystemVerilog";
    homepage = "https://vunit.github.io/index.html";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jleightcap ];
  };
}
