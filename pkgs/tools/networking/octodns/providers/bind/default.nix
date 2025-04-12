{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  octodns,
  pytestCheckHook,
  pythonOlder,
  dnspython,
  setuptools,
}:

buildPythonPackage rec {
  pname = "octodns-bind";
  version = "0.0.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-bind";
    rev = "v${version}";
    hash = "sha256-IxZr7Wds8wLfJg6rqCtJ59Sg/mCIJ1g9jDJ8CTM7O8w=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    octodns
    dnspython
  ];

  env.OCTODNS_RELEASE = 1;

  pythonImportsCheck = [ "octodns_bind" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = " RFC compliant (Bind9) provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-bind";
    changelog = "https://github.com/octodns/octodns-bind/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
