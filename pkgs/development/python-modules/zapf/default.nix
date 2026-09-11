{
  lib,
  buildPythonPackage,
  fetchgit,
  setuptools,
  setuptools-scm,
  numpy,
  pytango,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "zapf";
  version = "0.6.1";
  pyproject = true;

  src = fetchgit {
    url = "https://forge.frm2.tum.de/review/mlz/pils/zapf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dY3pmYbLzReXrMLjN5aZ2BVoKi1EtFGB/Gs1GoP4IDE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  # setuptools-scm normally derives the version from git tags/history, but
  # fetchgit gives a shallow, tag-less checkout by default. Pin the version
  # explicitly instead of also needing `leaveDotGit`/deepClone = true.
  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  dependencies = [
    numpy
  ];

  passthru.optional-dependencies = {
    tango = [ pytango ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zapf" ];

  meta = {
    description = "Client library for the PILS PLC interface specification";
    homepage = "https://forge.frm2.tum.de/review/plugins/gitiles/mlz/pils/zapf";
    changelog = "https://forge.frm2.tum.de/review/plugins/gitiles/mlz/pils/zapf/+/refs/tags/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ tincotema ];
  };
})
