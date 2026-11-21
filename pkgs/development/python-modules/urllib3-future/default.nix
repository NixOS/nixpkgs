{
  aiofile,
  brotli,
  brotlicffi,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  wsproto,
  zstandard,
}:

buildPythonPackage rec {
  pname = "urllib3-future";
  version = "2.20.906";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "urllib3.future";
    tag = version;
    hash = "sha256-XYZsnvFe4WNOAGN0TJuJiVVOHh5wElfngTPe6EfVJsE=";
  };

  patches = [
    # fix gzip responses with trailing garbage on Python with stricter zlib flush()
    (fetchpatch {
      url = "https://github.com/jawah/urllib3.future/commit/fe229e326a08f5a41cf26a06a422ae0a2282d5ad.patch";
      excludes = [ "CHANGES.rst" ];
      hash = "sha256-W52CVUzBI6JHvTObVOefzgnybDnCo+iGFDURXagpU2k=";
    })
  ];

  postPatch = ''
    # https://github.com/jawah/urllib3.future/commit/7adb310b643d0f785e5f7151b1240e9943ad27c8
    substituteInPlace test/test_ssltransport.py \
      --replace-fail "SSLTransport(sock, context)" "SSLTransport(sock, context, server_hostname=\"localhost\")"

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
    secure = [ ];
    socks = [ python-socks ];
    ws = [ wsproto ];
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
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    # test connects to the internet
    "test/contrib/test_resolver.py::test_url_resolver"
  ];

  meta = {
    changelog = "https://github.com/jawah/urllib3.future/blob/${src.tag}/CHANGES.rst";
    description = "Powerful HTTP 1.1, 2, and 3 client with both sync and async interfaces";
    homepage = "https://github.com/jawah/urllib3.future";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
