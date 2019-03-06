{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "twitter.common.options";
  version = "0.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9eeaf078462afdfa5ba237727c908a8b3b8b28d172838dbe58d3addf722da6c8";
  };

  meta = with stdenv.lib; {
    description = "Twitter's optparse wrapper";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
