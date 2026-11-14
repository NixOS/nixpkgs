{
  lib,
  asgineer,
  bcrypt,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  iptools,
  itemdb,
  jinja2,
  markdown,
  nodejs,
  platformdirs,
  pscript,
  pyjwt,
  pytestCheckHook,
  pythonAtLeast,
  requests,
  setuptools,
  uvicorn,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "timetagger";
  version = "26.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = "timetagger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X82Ai6E844deRGs6KcJATEid3X6IlDq4+LCEU4lc4hM=";
  };

  patches = [
    # PR https://github.com/almarklein/timetagger/pull/605
    (fetchpatch {
      url = "https://github.com/almarklein/timetagger/commit/8221a2a84e83c927c439379c256c53cc74efddb2.patch?full_index=1";
      hash = "sha256-raeiGJCCE+0q6Pu4srYs8HRgDYwzkFGsf62sow7YMeM=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    asgineer
    bcrypt
    iptools
    itemdb
    jinja2
    markdown
    platformdirs
    pscript
    pyjwt
    uvicorn
  ];

  nativeCheckInputs = [
    nodejs
    pytestCheckHook
    requests
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "timetagger" ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.14") [
    #  RuntimeError: There is no current event loop in thread 'MainThread'
    "tests/test_server_apiserver.py"
  ];

  meta = {
    description = "Library to interact with TimeTagger";
    homepage = "https://github.com/almarklein/timetagger";
    changelog = "https://github.com/almarklein/timetagger/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      phanirithvij
    ];
    mainProgram = "timetagger";
  };
})
