{ lib, buildPythonPackage, fetchPypi, openssl, async_generator, rsa, pyaes, pythonOlder }:

buildPythonPackage rec {
  pname = "telethon";
  version = "1.17.5";

  src = fetchPypi {
    inherit version;
    pname = "Telethon";
    sha256 = "1v1rgr030z8s1ldv5lm1811znyd568c22pmlrzzf3ls972xk514m";
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
