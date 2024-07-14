{
  lib,
  buildPythonPackage,
  fetchPypi,
  twitter-common-lang,
}:

buildPythonPackage rec {
  pname = "twitter.common.dirutil";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Sa7srSQ0rCPBarv8H8z/03kMBWqesBRo7CbIPmWhARk=";
  };

  propagatedBuildInputs = [ twitter-common-lang ];

  meta = with lib; {
    description = "Utilities for manipulating and finding files and directories";
    homepage = "https://twitter.github.io/commons/";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };
}
