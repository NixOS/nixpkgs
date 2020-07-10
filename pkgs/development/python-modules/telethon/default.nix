{ lib, buildPythonPackage, fetchPypi, async_generator, rsa, pyaes, pythonOlder }:

buildPythonPackage rec {
  pname = "telethon";
  version = "1.15.0";

  src = fetchPypi {
    inherit version;
    pname = "Telethon";
    sha256 = "0qg39dybhadk9ya8ayznxbsczw6y6zjkc9wkmw5i0r9k6nb18k1z";
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
    homepage = "https://github.com/LonamiWebs/Telethon";
    description = "Full-featured Telegram client library for Python 3";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
