<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "zfs-autobackup";
  version = "3.1.3";

  src = fetchPypi {
    inherit version;
    pname = "zfs_autobackup";
    sha256 = "sha256-ckikq8Am81O0wkL4ozRBFTCa15PrmkD54A2qEY6kA5c=";
  };

  nativeBuildInputs = with python3Packages; [ pythonRelaxDepsHook ];

  propagatedBuildInputs = with python3Packages; [ colorama ];

  pythonRemoveDeps = [ "argparse" ];

  # tests need zfs filesystem
  doCheck = false;

  pythonImportsCheck = [ "zfs_autobackup" ];

  meta = with lib; {
    description = "ZFS backup, replicationand snapshot tool";
    homepage = "https://github.com/psy0rz/zfs_autobackup";
    changelog = "https://github.com/psy0rz/zfs_autobackup/releases/tag/v${version}";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
