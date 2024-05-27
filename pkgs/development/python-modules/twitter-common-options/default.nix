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
    sha256 = "a495bcdffc410039bc4166f1a30c2caa3c92769d7a161a4a39d3651836dd27e1";
  };

  meta = with lib; {
    description = "Twitter's optparse wrapper";
    homepage = "https://twitter.github.io/commons/";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };
}
