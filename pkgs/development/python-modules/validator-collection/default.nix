{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  alabaster,
  attrs,
  babel,
  certifi,
  cffi,
  chardet,
  codecov,
  colorama,
  coverage,
  docutils,
  filelock,
  html5lib,
  idna,
  imagesize,
  isort,
  jinja2,
  jsonschema,
  lazy-object-proxy,
  markupsafe,
  mccabe,
  more-itertools,
  packaging,
  pkginfo,
  pluggy,
  py,
  py-cpuinfo,
  pycparser,
  pyfakefs,
  pygments,
  pyparsing,
  pytest,
  pytest-benchmark,
  pytest-cov,
  pytz,
  readme-renderer,
  requests,
  requests-toolbelt,
  restview,
  six,
  snowballstemmer,
  sphinx,
  sphinx-rtd-theme,
  sphinx-tabs,
  sphinxcontrib-websupport,
  toml,
  pytestCheckHook,
  tox,
  tqdm,
  twine,
  urllib3,
  virtualenv,
  webencodings,
  wrapt,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "validator-collection";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "insightindustry";
    repo = "validator-collection";
    rev = "refs/tags/v.${version}";
    hash = "sha256-CDPfIkZZRpl1rAzNpLKJfaBEGWUl71coic2jOHIgi6o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    alabaster
    attrs
    babel
    certifi
    cffi
    chardet
    codecov
    colorama
    coverage
    docutils
    filelock
    html5lib
    idna
    imagesize
    isort
    jinja2
    jsonschema
    lazy-object-proxy
    markupsafe
    mccabe
    more-itertools
    packaging
    pkginfo
    pluggy
    py
    py-cpuinfo
    pycparser
    pyfakefs
    pygments
    pyparsing
    pytest
    pytest-benchmark
    pytest-cov
    pytz
    readme-renderer
    requests
    requests-toolbelt
    restview
    six
    snowballstemmer
    sphinx
    sphinx-rtd-theme
    sphinx-tabs
    sphinxcontrib-websupport
    toml
    tox
    tqdm
    twine
    urllib3
    virtualenv
    webencodings
    wrapt
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "validator_collection" ];

  disabledTests = [
    # Issues with fake filesystem /var/data
    "test_writeable"
    "test_executable"
    "test_readable"
    "test_is_readable"
  ];

  meta = with lib; {
    description = "Python library of 60+ commonly-used validator functions";
    homepage = "https://github.com/insightindustry/validator-collection/";
    changelog = "https://github.com/insightindustry/validator-collection/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
