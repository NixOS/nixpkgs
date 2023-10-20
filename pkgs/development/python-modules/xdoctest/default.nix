{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xdoctest";
  version = "1.1.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2eac8131bdcdf2781b4e5a62d6de87f044b730cc8db8af142a51bb29c245e779";
  };

  propagatedBuildInputs = [
    six
  ];

  pythonImportCheck = [ "xdoctest" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # `xdoctest` executable is not found
    "test_xdoc_console_script"
  ];

  meta = with lib; {
    description = "A rewrite of the builtin doctest module";
    homepage = "https://github.com/Erotemic/xdoctest";
    license = licenses.asl20;
    maintainers = [ maintainers.malo ];
  };
}
