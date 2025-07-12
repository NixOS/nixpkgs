{
  # Basic
  lib,
  buildPythonPackage,
  fetchPypi,
  # Dependencies
  click,
  deprecated,
  networkx,
  tabulate,
}:

buildPythonPackage rec {

  pname = "tsplib95";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PagBdd+wR4uWe4fFCPdd70c3EYi2QBtxlEHyztyBfgA=";
  };

  dependencies = [
    click
    deprecated
    networkx
    tabulate
  ];

  # Remove deprecated pytest-runner
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'," ""
  '';

  meta = {
    description = "A library for working with TSPLIB 95 files.";
    homepage = "https://github.com/rhgrant10/tsplib95";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thattemperature ];
  };

}
