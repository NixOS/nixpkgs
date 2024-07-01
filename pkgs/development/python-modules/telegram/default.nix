{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "telegram";
  version = "0.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1495l2ml8mg120wfvqhikqkfczhwwaby40vdmsz8v2l69jps01fl";
  };

  meta = with lib; {
    homepage = "https://github.com/liluo/telegram";
    description = "Telegram APIs";
    license = licenses.mit;
  };
}
