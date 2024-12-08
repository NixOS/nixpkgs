{
  lib,
  attrs,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  idna,
  pyasn1,
  pyasn1-modules,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "service-identity";
  version = "24.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyca";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ibi9hls/VnVePv4fF2CyxI22P1RX6QpCwyeENWVPkx4=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    attrs
    cryptography
    idna
    pyasn1
    pyasn1-modules
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "service_identity" ];

  meta = with lib; {
    description = "Service identity verification for pyOpenSSL";
    homepage = "https://service-identity.readthedocs.io";
    changelog = "https://github.com/pyca/service-identity/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
