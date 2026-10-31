{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pysnmp,
  poetry-core,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "snmpsim";
  version = "1.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lextudio";
    repo = "snmpsim";
    rev = "v${version}";
    hash = "sha256-ku2u6/sMGf4P716B9qlhCNerslZ3txQh7V+Bq7DUvVk=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pysnmp ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  meta = {
    homepage = "https://github.com/lextudio/snmpsim";
    description = "SNMP Simulator";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ aviallon ];
  };
}
