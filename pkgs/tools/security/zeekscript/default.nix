{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zeekscript";
  version = "1.2.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LogI9sJHvLN5WHJGdW47D09XZInKln/I2hNmG62d1JU=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    tree-sitter
  ];

  pythonImportsCheck = [
    "zeekscript"
  ];

  meta = with lib; {
    description = "A Zeek script formatter and analyzer";
    homepage = "https://github.com/zeek/zeekscript";
    changelog = "https://github.com/zeek/zeekscript/blob/v${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab tobim ];
  };
}
