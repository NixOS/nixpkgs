{ stdenv
, buildPythonPackage
, fetchPypi
, twitter-common-lang
}:

buildPythonPackage rec {
  pname   = "twitter.common.dirutil";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wpjfmmxsdwnbx5dl13is4zkkpfcm94ksbzas9y2qhgswfa9jqha";
  };

  propagatedBuildInputs = [ twitter-common-lang ];

  meta = with stdenv.lib; {
    description = "Utilities for manipulating and finding files and directories";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
