{ lib
, python3
, fetchPypi
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy_1_4;
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "csvkit";
  version = "1.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uC5q4tK7QWUXEA7Lro1dhWoN/65CtxIIiBSityAeGvg=";
  };

  propagatedBuildInputs = with python.pkgs; [
    agate
    agate-excel
    agate-dbf
    agate-sql
    setuptools # csvsql imports pkg_resources
  ];

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "csvkit"
  ];

  disabledTests = [
    # Test is comparing CLI output
    "test_decimal_format"
  ];

  meta = with lib; {
    changelog = "https://github.com/wireservice/csvkit/blob/${version}/CHANGELOG.rst";
    description = "A suite of command-line tools for converting to and working with CSV";
    homepage = "https://github.com/wireservice/csvkit";
    license = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
  };
}
