{ lib
, buildPythonPackage
, fetchPypi
, openssl
, async_generator
, rsa
, pyaes
, pythonOlder
}:

buildPythonPackage rec {
  pname = "telethon";
  version = "1.21.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit version;
    pname = "Telethon";
    sha256 = "sha256-mTyDfvdFrd+XKifXv7oM5Riihj0aUOBzclW3ZNI+DvI=";
  };

  patchPhase = ''
    substituteInPlace telethon/crypto/libssl.py --replace \
      "ctypes.util.find_library('ssl')" "'${openssl.out}/lib/libssl.so'"
  '';

  propagatedBuildInputs = [
    rsa
    pyaes
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [ "telethon" ];

  meta = with lib; {
    homepage = "https://github.com/LonamiWebs/Telethon";
    description = "Full-featured Telegram client library for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
