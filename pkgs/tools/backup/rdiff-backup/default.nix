<<<<<<< HEAD
{ lib, python3Packages, fetchPypi, librsync }:
=======
{ lib, python3Packages, librsync }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let
  pypkgs = python3Packages;

in
pypkgs.buildPythonApplication rec {
  pname = "rdiff-backup";
<<<<<<< HEAD
  version = "2.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0HeDVyZrxlE7t/daRXCymySydgNIu/YHur/DpvCUWM8";
  };

  nativeBuildInputs = with pypkgs; [ setuptools-scm ];

  buildInputs = [ librsync ];

  propagatedBuildInputs = with pypkgs; [ pyyaml ];
=======
  version = "2.0.5";

  src = pypkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-VNFgOOYgFO2RbHHIMDsH0vphpqaAOMoYn8LTFTSw84s=";
  };

  # pkg_resources fails to find the version and then falls back to "DEV"
  postPatch = ''
    substituteInPlace src/rdiff_backup/Globals.py \
      --replace 'version = "DEV"' 'version = "${version}"'
  '';

  buildInputs = [ librsync ];

  nativeBuildInputs = with pypkgs; [ setuptools-scm ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
