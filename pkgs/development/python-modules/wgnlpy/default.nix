{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # see https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/83019
    # Required for ifstate
    # Upstream Issue/PR: https://github.com/ArgosyLabs/wgnlpy/pull/5
    (fetchpatch {
      url = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/1f78a31dc3e8d7ffd4ff4b8c32fabc3ad0265ae2/community/py3-wgnlpy/0001-fix-exception-when-WGPEER_A_LAST_HANDSHAKE_TIME-is-N.patch";
      hash = "sha256-MO5MMDXnaCPdakMlxCkiCBCDCiTFdG3V66l+AKb95X4=";
    })
  ];

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
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ marcel ];
  };
}
