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
  version = "5.4.4"; # version needs to be compatible with APScheduler

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jbuGYIOGiKe2uk/tMdGN7fhCr7TUfKBQ1tiRwsFfO+Q=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
