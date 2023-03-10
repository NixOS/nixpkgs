{ lib, python3Packages }:

let
  pythonPackages = python3Packages;

in
pythonPackages.buildPythonApplication rec {
  pname = "zfs_autobackup";
  version = "3.1";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "42c22001717b3d7cfdae6297fedc11b2dd1eb2a4bd25b6bb1c9232dd3b70ad67";
  };

  # argparse is part of the standardlib
  prePatch = ''
    substituteInPlace setup.py --replace "argparse" ""
  '';

  propagatedBuildInputs = with pythonPackages; [ colorama ];

  # tests need zfs filesystem
  doCheck = false;
  pythonImportsCheck = [ "colorama" "argparse" ];

  meta = with lib; {
    homepage = "https://github.com/psy0rz/zfs_autobackup";
    description = "ZFS backup, replicationand snapshot tool";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
