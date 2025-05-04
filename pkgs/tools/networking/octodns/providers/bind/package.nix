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
  version = "0.0.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-bind";
    rev = "v${version}";
    hash = "sha256-cJbmGh0YNIu9fYH4It5SZG39ZsFoiOBERQXRd7kz8FY=";
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

  meta = {
    description = "RFC compliant (Bind9) provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-bind";
    changelog = "https://github.com/octodns/octodns-bind/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = lib.teams.octodns.members;
  };
}
