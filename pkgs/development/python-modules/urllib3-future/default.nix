{
  aiofile,
  brotli,
  brotlicffi,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  h11,
  isPyPy,
  jh2,
  lib,
  pytest-asyncio,
  pytest-rerunfailures,
  pytest-timeout,
  pytestCheckHook,
  python-socks,
  pythonOlder,
  qh3,
  stdenv,
  tornado,
  trustme,
  websockets,
  wsproto,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "urllib3-future";
  version = "2.25.904";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "urllib3.future";
    tag = finalAttrs.version;
    hash = "sha256-ihNH2C6dd0t4UMOczFUAXfL8/4lPD+eiKBdUltIX5Co=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "''''ignore:.*but not measured.*:coverage.exceptions.CoverageWarning''''," "" \
      --replace-fail "''''ignore:.*No data was collected.*:coverage.exceptions.CoverageWarning''''," ""
  '';

  build-system = [ hatchling ];

  # prevents installing a urllib3 module and thereby shadow the urllib3 package
  env.URLLIB3_NO_OVERRIDE = "true";

  dependencies = [
    h11
    jh2
    qh3
  ];

  optional-dependencies = {
    brotli = [ (if isPyPy then brotlicffi else brotli) ];
    qh3 = [ qh3 ];
    # FIXME package rtls
    # rtls = lib.optionals (!isPyPy) [ rtls ];
    secure = [ ];
    socks = [ python-socks ];
    # FIXME package utls
    # utls = lib.optionals (!isPyPy) [
    #   brotli
    #   utls
    #   zstandard
    # ];
    ws = [ wsproto ];
    ws-fast = [ websockets ];
    zstd = lib.optionals (pythonOlder "3.14") [ zstandard ];
  };

  pythonImportsCheck = [ "urllib3_future" ];

  # PermissionError: [Errno 1] Operation not permitted
  doCheck = !stdenv.buildPlatform.isDarwin;

  nativeCheckInputs = [
    aiofile
    pytest-asyncio
    pytest-rerunfailures
    pytest-timeout
    pytestCheckHook
    tornado
    trustme
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pytestFlags = [
    "-Wignore::pytest.PytestRemovedIn10Warning"
  ];

  disabledTestPaths = [
    # test connects to the internet
    "test/contrib/test_resolver.py::test_url_resolver"
    # https://github.com/jawah/urllib3.future/issues/437
    "test/contrib/asynchronous/test_socks.py"
    "test/contrib/test_socks.py"
  ];

  meta = {
    changelog = "https://github.com/jawah/urllib3.future/blob/${finalAttrs.src.tag}/CHANGES.rst";
    description = "Powerful HTTP 1.1, 2, and 3 client with both sync and async interfaces";
    homepage = "https://github.com/jawah/urllib3.future";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
