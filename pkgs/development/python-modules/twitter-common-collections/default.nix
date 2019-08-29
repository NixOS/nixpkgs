{ stdenv
, buildPythonPackage
, fetchPypi
, twitter-common-lang
}:

buildPythonPackage rec {
  pname   = "twitter.common.collections";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ede4caff74928156f7ff38dac9b0811893de41966c39cd5b2fdea53418349ca8";
  };

  propagatedBuildInputs = [ twitter-common-lang ];

  meta = with stdenv.lib; {
    description = "Twitter's common collections";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
