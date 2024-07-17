{
  lib,
  python3Packages,
  fetchPypi,
  librsync,
}:

let
  pypkgs = python3Packages;

in
pypkgs.buildPythonApplication rec {
  pname = "rdiff-backup";
  version = "2.2.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0HeDVyZrxlE7t/daRXCymySydgNIu/YHur/DpvCUWM8";
  };

  nativeBuildInputs = with pypkgs; [ setuptools-scm ];

  buildInputs = [ librsync ];

  propagatedBuildInputs = with pypkgs; [ pyyaml ];

  # no tests from pypi
  doCheck = false;

  meta = with lib; {
    description = "Backup system trying to combine best a mirror and an incremental backup system";
    homepage = "https://rdiff-backup.net";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
