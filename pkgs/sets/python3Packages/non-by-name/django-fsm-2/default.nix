{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  django,
  django-stubs-ext,

  # optional-dependencies
  graphviz,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-fsm-2";
  # 4.3.0 changed the `State.get_state` signature, breaking inventree
  version = "4.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-commons";
    repo = "django-fsm-2";
    tag = finalAttrs.version;
    hash = "sha256-iSFNhAJNrag7EeLO55TFonGU9E0P1mqJtR8PGwK1QCk=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    django
    django-stubs-ext
  ];

  optional-dependencies = {
    graphviz = [
      graphviz
    ];
  };

  pythonImportsCheck = [ "django_fsm" ];

  # The test suite requires django-fsm-log (not packaged, and itself depends on django-fsm-2)
  doCheck = false;

  meta = {
    description = "Django friendly finite state machine support";
    homepage = "https://github.com/django-commons/django-fsm-2";
    changelog = "https://github.com/django-commons/django-fsm-2/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
