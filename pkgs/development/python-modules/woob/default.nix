{
  lib,
  babel,
  buildPythonPackage,
  fetchFromGitLab,
  fetchpatch,
  html2text,
  lxml,
  packaging,
  pillow,
  prettytable,
  pycountry,
  pytestCheckHook,
  python-dateutil,
  python-jose,
  pythonOlder,
  pyyaml,
  requests,
  rich,
  setuptools,
  testers,
  unidecode,
  woob,
}:

buildPythonPackage rec {
  pname = "woob";
  version = "3.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "woob";
    repo = "woob";
    rev = version;
    hash = "sha256-M9AjV954H1w64YGCVxDEGGSnoEbmocG3zwltob6IW04=";
  };

  patches = [
    (fetchpatch {
      name = "no-deprecated-pkg_resources.patch";
      url = "https://gitlab.com/woob/woob/-/commit/3283c4c1a935cc71acea98b2d8c88bc4bf28f643.patch";
      hash = "sha256-3bRuv93ivKRxbGr52coO023DlxHZWwUeInXTPqQAeL8=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  pythonRelaxDeps = [ "packaging" ];

  propagatedBuildInputs = [
    babel
    python-dateutil
    python-jose
    html2text
    lxml
    packaging
    pillow
    prettytable
    pycountry
    pyyaml
    requests
    rich
    unidecode
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # require networking
    "test_ciphers"
    "test_verify"
  ];

  pythonImportsCheck = [ "woob" ];

  passthru.tests.version = testers.testVersion {
    package = woob;
    version = "v${version}";
  };

  meta = with lib; {
    changelog = "https://gitlab.com/woob/woob/-/blob/${src.rev}/ChangeLog";
    description = "Collection of applications and APIs to interact with websites";
    mainProgram = "woob";
    homepage = "https://woob.tech";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ DamienCassou ];
  };
}
