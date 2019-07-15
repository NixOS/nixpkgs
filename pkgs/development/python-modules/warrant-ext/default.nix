{ lib, fetchPypi, buildPythonPackage, boto3, python-jose-ext, mock, requests, envs, future, pycryptodomex, ecdsa }:

buildPythonPackage rec {
  pname = "warrant-ext";
  version = "0.6.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vhadzicx87ny2alavg0a5yimc4hdwrxqaj1mha0wjjy8f0jkz65";
  };

  buildInputs = [ boto3 python-jose-ext mock requests envs future pycryptodomex ecdsa ];

  doCheck = false;

  meta = {
    homepage = https://github.com/capless/warrant;
    description = "extensions for warrant";
    maintainers = with lib.maintainers; [ mog ];
    license = lib.licenses.asl20;
  };
}
