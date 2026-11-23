{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  babel,
  html2text,
  lxml,
  packaging,
  pillow,
  prettytable,
  pycountry,
  pytestCheckHook,
  python-dateutil,
  pyjwt,
  pyyaml,
  requests,
  rich,
  setuptools,
  testers,
  unidecode,
  termcolor,
  responses,
  woob,
}:

buildPythonPackage rec {
  pname = "woob";
  version = "3.7";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "woob";
    repo = "woob";
    tag = version;
    hash = "sha256-EZHzw+/BIIvmDXG4fF367wsdUTVTHWYb0d0U56ZXwOs=";
  };

  build-system = [ setuptools ];

  # python-jose is marked insecure and only used to read unverified claims
  # https://gitlab.com/woob/woob/-/work_items/869
  postPatch = ''
    substituteInPlace modules/caissedepargne/browser.py modules/bouygues/browser.py \
      --replace-fail "from jose import jwt" "import jwt"
    substituteInPlace modules/caissedepargne/browser.py \
      --replace-fail "jwt.get_unverified_claims(self.id_token)" "jwt.decode(self.id_token, options={'verify_signature': False})"
    substituteInPlace modules/bouygues/browser.py \
      --replace-fail "jwt.get_unverified_claims(fragments['id_token'])" "jwt.decode(fragments['id_token'], options={'verify_signature': False})"
  '';

  pythonRelaxDeps = [
    "packaging"
    "rich"
    "requests"
  ];

  dependencies = [
    babel
    python-dateutil
    pyjwt
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
    termcolor
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

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

  meta = {
    changelog = "https://gitlab.com/woob/woob/-/blob/${src.rev}/ChangeLog";
    description = "Collection of applications and APIs to interact with websites";
    mainProgram = "woob";
    homepage = "https://woob.tech";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ DamienCassou ];
  };
}
