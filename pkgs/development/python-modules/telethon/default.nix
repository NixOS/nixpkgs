{ lib, buildPythonPackage, fetchPypi, async_generator, rsa, pyaes, pythonOlder }:

buildPythonPackage rec {
  pname = "telethon";
  version = "1.5.5";

  src = fetchPypi {
    inherit version;
    pname = "Telethon";
    sha256 = "1qpc4vc3lidhlp1c7521nxizjr6y5c3l9x41knqv02x8n3l9knxa";
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
