{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # frontend
  fetchNpmDeps,
  nodejs,
  npmHooks,

  # build-system
  setuptools,

  # dependencies
  anyascii,
  beautifulsoup4,
  django,
  django-filter,
  django-modelcluster,
  django-taggit,
  django-tasks,
  django-treebeard,
  djangorestframework,
  draftjs-exporter,
  laces,
  modelsearch,
  openpyxl,
  permissionedforms,
  pillow,
  requests,
  telepath,
  willow,

  # tests
  callPackage,
}:

let
  # updating django-treebeard regularly requires changes in code
  django-treebeard' = django-treebeard.overridePythonAttrs (old: {
    version = "5.3.1";
    src = old.src.override {
      hash = "sha256-s2s/cN1daeST9YxvjwJSH4mbT/gg5/J3n4F6g+S15Rc=";
    };
  });
in
buildPythonPackage (finalAttrs: {
  pname = "wagtail";
  version = "7.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = "wagtail";
    tag = "v${finalAttrs.version}";
    hash = "sha256-26x2Uv8rkuFiF0Zx5lYtGZgPC2wS2FnbOXBHYQ4EtT0=";
  };

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
  ];

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-Z2VOMqsNIBybJpfYxAq2dkmS2vwd8Yuhu7MCFyqNxdI=";
  };

  preBuild = ''
    # upstream only provides a hook for sdists, not wheels
    # https://github.com/wagtail/wagtail/blob/v7.3/setup.py#L22
    npm run build
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    anyascii
    beautifulsoup4
    django
    django-filter
    django-modelcluster
    django-taggit
    django-tasks
    django-treebeard'
    djangorestframework
    draftjs-exporter
    laces
    modelsearch
    openpyxl
    permissionedforms
    pillow
    requests
    telepath
    willow
  ]
  ++ willow.optional-dependencies.heif;

  # Tests are in separate derivation because they require a package that depends
  # on wagtail (wagtail-factories)
  doCheck = false;

  passthru.tests.wagtail = callPackage ./tests.nix { };

  pythonImportsCheck = [ "wagtail" ];

  meta = {
    description = "Django content management system focused on flexibility and user experience";
    mainProgram = "wagtail";
    homepage = "https://github.com/wagtail/wagtail";
    changelog = "https://github.com/wagtail/wagtail/blob/${finalAttrs.src.tag}/CHANGELOG.txt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sephi ];
  };
})
