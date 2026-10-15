{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  requests,
  mock,
  pytestCheckHook,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "stups-tokens";
  version = "1.1.19";
  pyproject = true;
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "zalando-stups";
    repo = "python-tokens";
    rev = version;
    hash = "sha256-NQKNZsrZoMF+QL4tLms5NbUPZpgvkBDXjpfT9vug4yc=";
  };

  postPatch = ''
    substituteInPlace tokens/__init__.py \
      --replace-fail "__version__ = '0.8'" "__version__ = '${version}'"
  '';

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  meta = {
    description = "Python library that keeps OAuth 2.0 service access tokens in memory for your usage";
    homepage = "https://github.com/zalando-stups/python-tokens";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.mschuwalow ];
  };
}
