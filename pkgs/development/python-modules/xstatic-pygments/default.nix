{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-Pygments";
  version = "2.7.2.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "b22b0a59ce17bf06e26508fdd264fff74409ebd9968af87a0a63402fce838dc2";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage = "https://pygments.org";
    description = "pygments packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
