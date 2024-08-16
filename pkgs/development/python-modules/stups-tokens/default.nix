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
    sha256 = "09z3l3xzdlwpivbi141gk1k0zd9m75mjwbdy81zc386rr9k8s0im";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python library that keeps OAuth 2.0 service access tokens in memory for your usage";
    homepage = "https://github.com/zalando-stups/python-tokens";
    license = licenses.asl20;
    maintainers = [ maintainers.mschuwalow ];
  };
}
