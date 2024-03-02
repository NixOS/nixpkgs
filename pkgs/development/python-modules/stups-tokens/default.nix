{ lib
, fetchFromGitHub
, buildPythonPackage
, requests
, mock
, pytest
, pytest-cov
, isPy3k
}:

buildPythonPackage rec {
  pname = "stups-tokens";
  version = "1.1.19";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "zalando-stups";
    repo = "python-tokens";
    rev = version;
    sha256 = "09z3l3xzdlwpivbi141gk1k0zd9m75mjwbdy81zc386rr9k8s0im";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    mock
    pytest
    pytest-cov
  ];

  meta = with lib; {
    description = "A Python library that keeps OAuth 2.0 service access tokens in memory for your usage.";
    homepage = "https://github.com/zalando-stups/python-tokens";
    license = licenses.asl20;
    maintainers = [ maintainers.mschuwalow ];
  };
}
