{ lib, buildPythonPackage, fetchPypi, async_generator, rsa, pyaes, pythonOlder }:

buildPythonPackage rec {
  pname = "telethon";
  version = "1.10.9";

  src = fetchPypi {
    inherit version;
    pname = "Telethon";
    sha256 = "16qb5hv8kh4plic1155ky9b88xz9iahhv1s3h47678hl7mjy2jc7";
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
