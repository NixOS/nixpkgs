{ stdenv
, buildPythonPackage
, fetchPypi
, twitter-common-lang
}:

buildPythonPackage rec {
  pname   = "twitter.common.dirutil";
  version = "0.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "748b471bb2dd78f14e39d796cb01407aa8b61dda95808543404d5da50385efaf";
  };

  propagatedBuildInputs = [ twitter-common-lang ];

  meta = with stdenv.lib; {
    description = "Utilities for manipulating and finding files and directories";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
