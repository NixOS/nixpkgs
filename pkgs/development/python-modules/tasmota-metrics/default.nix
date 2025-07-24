{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "tasmota-metrics";
  version = "0.4.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pl9JIdsR/GaNmzXdRRDCEsILp9V4ZGIlRVj/ZcGCAi0=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
    python3.pkgs.pyyaml
  ];

  pythonImportsCheck = [ "tasmota_metrics" ];

  meta = with lib; {
    description = "Show metrics of espressif firmware map";
    homepage = "https://github.com/Jason2866/tasmota-metrics";
    license = licenses.asl20;
    maintainers = with maintainers; [ davhau ];
    mainProgram = "tasmota-metrics";
  };
}
