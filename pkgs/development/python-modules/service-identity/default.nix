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
  pyopenssl,
}:

buildPythonPackage rec {
  pname = "service-identity";
  version = "24.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyca";
    repo = "service-identity";
    tag = version;
    hash = "sha256-onxCUWqGVeenLqB5lpUpj3jjxTM61ogXCQOGnDnClT4=";
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

  checkInputs = [ pyopenssl ];

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
