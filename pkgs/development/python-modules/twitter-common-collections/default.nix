{ stdenv
, buildPythonPackage
, fetchPypi
, twitter-common-lang
}:

buildPythonPackage rec {
  pname   = "twitter.common.collections";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wf8ks6y2kalx2inzayq0w4kh3kg25daik1ac7r6y79i03fslsc5";
  };

  propagatedBuildInputs = [ twitter-common-lang ];

  meta = with stdenv.lib; {
    description = "Twitter's common collections";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
