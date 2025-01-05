{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  pyroute2,
}:

buildPythonPackage rec {
  pname = "wgnlpy";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ArgosyLabs";
    repo = "wgnlpy";
    rev = "v${version}";
    hash = "sha256-5XAfBiKx4SqouA57PxmaCb0ea7mT2VeUI1tgnQE/ZwQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    pyroute2
  ];

  pythonImportsCheck = [
    "wgnlpy"
    "wgnlpy.nlas"
  ];

  meta = {
    description = "Netlink connector to WireGuard";
    homepage = "https://github.com/ArgosyLabs/wgnlpy";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ marcel ];
  };
}
