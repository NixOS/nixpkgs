{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "twitter.common.options";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pJW83/xBADm8QWbxowwsqjySdp16FhpKOdNlGDbdJ+E=";
  };

  meta = with lib; {
    description = "Twitter's optparse wrapper";
    homepage = "https://twitter.github.io/commons/";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };
}
