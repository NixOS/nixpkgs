{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wyoming-piper";
  version = "1.3.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "wyoming_piper";
    inherit version;
    hash = "sha256-WyoHwIF3xC5nOa7iQ8/esfdwahbU6YJzK5G2Vi3mV4M=";
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
