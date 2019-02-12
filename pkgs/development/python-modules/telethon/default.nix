{ lib, buildPythonPackage, fetchPypi, async_generator, rsa, pyaes, pythonOlder }:

buildPythonPackage rec {
  pname = "telethon";
  version = "1.5.4";

  src = fetchPypi {
    inherit version;
    pname = "Telethon";
    sha256 = "52cb4929bf37c98ab5f3e173325dbb3cb9c1ca3f4fe6ba87d35c43e2f98858ce";
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
