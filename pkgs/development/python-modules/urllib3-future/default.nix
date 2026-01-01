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
<<<<<<< HEAD
  version = "2.15.901";
=======
  version = "2.14.907";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "urllib3.future";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-RffHaGJmbfI56QKgIIgSdGSaKZ/WGSNTZce8kck8neY=";
=======
    hash = "sha256-LdJplIA/hUIHmDNJKUwcr5ganKaxEQMGhjQsc5FcEjI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    pytest-timeout
    pytestCheckHook
    tornado
    trustme
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
