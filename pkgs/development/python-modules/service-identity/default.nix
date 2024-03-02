{ lib
, attrs
, buildPythonPackage
, cryptography
, fetchFromGitHub
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, idna
, pyasn1
, pyasn1-modules
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "service-identity";
  version = "23.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyca";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PGDtsDgRwh7GuuM4OuExiy8L4i3Foo+OD0wMrndPkvo=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "service_identity"
  ];

  meta = with lib; {
    description = "Service identity verification for pyOpenSSL";
    homepage = "https://service-identity.readthedocs.io";
    changelog = "https://github.com/pyca/service-identity/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
