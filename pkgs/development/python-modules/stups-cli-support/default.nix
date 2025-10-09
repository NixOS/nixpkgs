{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  clickclick,
  dnspython,
  requests,
  pytestCheckHook,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "stups-cli-support";
  version = "1.1.22";
  pyproject = true;
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "zalando-stups";
    repo = "stups-cli-support";
    rev = version;
    sha256 = "sha256-/UsQzV1Ljd+K8AIj55UmiVXAshX+rUbYxFeSK7YGgn8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    clickclick
    dnspython
    requests
  ];

  preCheck = "export HOME=$TEMPDIR";

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Helper library for all STUPS command line tools";
    homepage = "https://github.com/zalando-stups/stups-cli-support";
    license = licenses.asl20;
    maintainers = [ maintainers.mschuwalow ];
  };
}
