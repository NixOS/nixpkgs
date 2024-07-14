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
    hash = "sha256-1AWgr0yGio2+rm0D4pfiHH7mJp4R4u04EOFVRKugJZE=";
  };

  meta = with lib; {
    homepage = "https://github.com/liluo/telegram";
    description = "Telegram APIs";
    license = licenses.mit;
  };
}
