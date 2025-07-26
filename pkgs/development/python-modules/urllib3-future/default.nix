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
  pytest-timeout,
  pytestCheckHook,
  python-socks,
  qh3,
  stdenv,
  tornado,
  trustme,
  wsproto,
  zstandard,
}:

buildPythonPackage rec {
  pname = "urllib3-future";
  version = "2.13.900";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "urllib3.future";
    tag = version;
    hash = "sha256-iSAXeLnyJLLBGx5AQu9xVbkLkitRs33ScPiE5Mw46w0=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/jawah/urllib3.future/commit/9a6647447c9c5600d25f6aaecb091f501e46a664.patch";
      hash = "sha256-7MeEWp7F9BEru6R6iJIyGT7xLdFDygvepbfQDRxtekI=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "''''ignore:.*but not measured.*:coverage.exceptions.CoverageWarning''''," ""
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
    socks = [ python-socks ];
    ws = [ wsproto ];
    zstd = [ zstandard ];
  };

  pythonImportsCheck = [ "urllib3_future" ];

  # PermissionError: [Errno 1] Operation not permitted
  doCheck = !stdenv.buildPlatform.isDarwin;

  nativeCheckInputs = [
    aiofile
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
    tornado
    trustme
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTestPaths = [
    # test connects to the internet
    "test/contrib/test_resolver.py::test_url_resolver"
  ];

  disabledTests = [
    # test hangs
    "test_proxy_rejection"
  ];

  meta = {
    changelog = "https://github.com/jawah/urllib3.future/blob/${src.tag}/CHANGES.rst";
    description = "Powerful HTTP 1.1, 2, and 3 client with both sync and async interfaces";
    homepage = "https://github.com/jawah/urllib3.future";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
