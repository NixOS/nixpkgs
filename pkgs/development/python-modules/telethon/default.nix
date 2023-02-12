{ lib
, buildPythonPackage
, fetchFromGitHub
, openssl
, rsa
, pyaes
, pythonOlder
, setuptools
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "telethon";
  version = "1.26.1";
  format = "pyproject";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "LonamiWebs";
    repo = "Telethon";
    rev = "refs/tags/v${version}";
    hash = "sha256-RxnC+PVSnLeCZ1xap6n6CjpeA8Ig6oLGiB0LDxqUmsA=";
  };

  patchPhase = ''
    substituteInPlace telethon/crypto/libssl.py --replace \
      "ctypes.util.find_library('ssl')" "'${lib.getLib openssl}/lib/libssl.so'"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    rsa
    pyaes
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/telethon"
  ];

  meta = with lib; {
    homepage = "https://github.com/LonamiWebs/Telethon";
    description = "Full-featured Telegram client library for Python 3";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
