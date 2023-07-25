{ lib, python3Packages, fetchPypi, librsync }:

let
  pypkgs = python3Packages;

in
pypkgs.buildPythonApplication rec {
  pname = "rdiff-backup";
  version = "2.0.5";

  src = fetchPypi {
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
