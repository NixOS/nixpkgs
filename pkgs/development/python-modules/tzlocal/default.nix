{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "tzlocal";
  version = "5.4.4"; # version needs to be compatible with APScheduler
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "regebro";
    repo = "tzlocal";
    tag = finalAttrs.version;
    hash = "sha256-kZ3+YpmJJ7ZHKbEp5RELVnGtwAOJph19Wf32lwuokNM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = lib.optional stdenv.hostPlatform.isDarwin "test_assert_tz_offset";

  pythonImportsCheck = [ "tzlocal" ];

  meta = {
    description = "Tzinfo object for the local timezone";
    homepage = "https://github.com/regebro/tzlocal";
    changelog = "https://github.com/regebro/tzlocal/blob/${finalAttrs.src.tag}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
