{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  requests,
  stups-cli-support,
  stups-zign,
  pytestCheckHook,
  hypothesis,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "stups-pierone";
  version = "1.1.51";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zalando-stups";
    repo = "pierone-cli";
    rev = version;
    hash = "sha256-OypGYHfiFUfcUndylM2N2WfPnfXXJ4gvWypUbltYAYE=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "stups-zign" ];

  dependencies = [
    requests
    stups-cli-support
    stups-zign
  ];

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "pierone" ];

  meta = with lib; {
    description = "Convenient command line client for STUPS' Pier One Docker registry";
    homepage = "https://github.com/zalando-stups/pierone-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ mschuwalow ];
  };
}
