{ lib, buildPythonPackage, fetchPypi, async_generator, rsa, pyaes, pythonOlder }:

buildPythonPackage rec {
  pname = "telethon";
  version = "1.10.8";

  src = fetchPypi {
    inherit version;
    pname = "Telethon";
    sha256 = "1v0zq6kdvcff6pygi8syylqndamz884gaby4v16p5brg5rz6k25g";
  };

  propagatedBuildInputs = [
    async_generator
    rsa
    pyaes
  ];

  # No tests available
  doCheck = false;

  disabled = pythonOlder "3.5";

  meta = with lib; {
    homepage = https://github.com/LonamiWebs/Telethon;
    description = "Full-featured Telegram client library for Python 3";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
