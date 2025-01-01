{
  lib,
  aenum,
  aiodns,
  aiohttp,
  buildPythonPackage,
  setuptools,
  faust-cchardet,
  fetchFromGitHub,
  pyopenssl,
  pythonOlder,
  pytz,
  related,
  uonet-request-signer-hebe,
  yarl,
}:

buildPythonPackage rec {
  pname = "vulcan-api";
  version = "2.4.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kapi2289";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FEWm5DvnrEIelRnu/IgWU7h1CTvPQcZ3DbFS2swy/wQ=";
  };

  pythonRemoveDeps = [ "related-without-future" ];

  build-system = [ setuptools ];

  dependencies = [
    aenum
    aiodns
    aiohttp
    faust-cchardet
    pyopenssl
    pytz
    related
    uonet-request-signer-hebe
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "vulcan" ];

  meta = with lib; {
    description = "Python library for UONET+ e-register API";
    homepage = "https://vulcan-api.readthedocs.io/";
    changelog = "https://github.com/kapi2289/vulcan-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
