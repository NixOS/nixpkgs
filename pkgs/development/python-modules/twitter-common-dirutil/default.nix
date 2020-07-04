{ stdenv
, buildPythonPackage
, fetchPypi
, twitter-common-lang
}:

buildPythonPackage rec {
  pname   = "twitter.common.dirutil";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "49aeecad2434ac23c16abbfc1fccffd3790c056a9eb01468ec26c83e65a10119";
  };

  propagatedBuildInputs = [ twitter-common-lang ];

  meta = with stdenv.lib; {
    description = "Utilities for manipulating and finding files and directories";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
