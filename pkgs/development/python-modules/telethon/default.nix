{ lib, buildPythonPackage, fetchPypi, openssl, async_generator, rsa, pyaes, pythonOlder }:

buildPythonPackage rec {
  pname = "telethon";
  version = "1.23.0";

  src = fetchPypi {
    inherit version;
    pname = "Telethon";
    sha256 = "sha256-unVRzkR+lUqtZ/PuukurdXTMoHosb0HlvmmQTm4OwxM=";
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

  disabled = pythonOlder "3.5";

  meta = with lib; {
    homepage = "https://github.com/LonamiWebs/Telethon";
    description = "Full-featured Telegram client library for Python 3";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
