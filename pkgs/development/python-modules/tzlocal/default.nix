{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tzlocal";
  version = "5.3.1"; # version needs to be compatible with APScheduler

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zO/8ft7O/qH1lVQdvW6ZDLHqPRm/AbKAnzYqA915If0=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    "test_conflicting"
    "test_noconflict"
    "test_symlink_localtime"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "test_assert_tz_offset";

  pythonImportsCheck = [ "tzlocal" ];

  meta = {
    description = "Tzinfo object for the local timezone";
    homepage = "https://github.com/regebro/tzlocal";
    changelog = "https://github.com/regebro/tzlocal/blob/${version}/CHANGES.txt";
    license = lib.licenses.cddl;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
