{
  lib,
  buildPythonPackage,
  fetchPypi,
  twitter-common-options,
  twitter-common-dirutil,
}:

buildPythonPackage rec {
  pname = "twitter.common.log";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cWCoZO7TAERwXgW4Fgd90ZOuwMZvUO8cB3t/hJDg0Go=";
  };

  propagatedBuildInputs = [
    twitter-common-options
    twitter-common-dirutil
  ];

  meta = with lib; {
    description = "Twitter's common logging library";
    homepage = "https://twitter.github.io/commons/";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };
}
