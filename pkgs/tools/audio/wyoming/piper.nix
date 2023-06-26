{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wyoming-piper";
  version = "0.0.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "wyoming_piper";
    inherit version;
    hash = "sha256-vl7LjW/2HBx6o/+vpap+wSG3XXzDwFacNmcbeU/8bOs=";
  };

  patches = [
    ./piper-entrypoint.patch
  ];

  propagatedBuildInputs = with python3.pkgs; [
    wyoming
  ];

  pythonImportsCheck = [
    "wyoming_piper"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Wyoming Server for Piper";
    homepage = "https://pypi.org/project/wyoming-piper/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
