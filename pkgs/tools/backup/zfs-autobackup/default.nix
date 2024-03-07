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
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
