{
  lib,
  buildPythonPackage,
  fetchPypi,
  twitter-common-log,
}:

buildPythonPackage rec {
  pname = "twitter.common.confluence";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Mj3eLFGfhQIFadejQ0MvOqwWvObr5eNHdNveVXKWaXw=";
  };

  propagatedBuildInputs = [ twitter-common-log ];

  meta = with lib; {
    description = "Twitter's API to the confluence wiki";
    homepage = "https://twitter.github.io/commons/";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };
}
