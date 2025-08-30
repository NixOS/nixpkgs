{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  pytestCheckHook,
  setuptools,
}:
buildPythonPackage rec {
  pname = "snapshot-restore-py";
  version = "1.0.0";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "snapshot-restore-py";
    tag = "v${version}";
    hash = "sha256-sixVSQcEqLTUrKxYAM13gzqttWnbXPMII0V/gtXM1IE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "snapshot_restore_py" ];

  meta = {
    description = "Snapshot Restore for Python library which can be used for registering runtime hooks in Snapstart enabled Python Lambda functions";
    homepage = "https://github.com/aws/snapshot-restore-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ austinbutler ];
    platforms = lib.platforms.all;
  };
}
