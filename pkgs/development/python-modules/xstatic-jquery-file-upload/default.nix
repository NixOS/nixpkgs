{ buildPythonPackage
, lib
, fetchPypi
, xstatic-jquery
}:

buildPythonPackage rec {
  pname = "XStatic-jQuery-File-Upload";
  version = "9.7.0.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0d5za18lhzhb54baxq8z73wazq801n3qfj5vgcz7ri3ngx7nb0cg";
  };

  # no tests implemented
  doCheck = false;

  propagatedBuildInputs = [ xstatic-jquery ];

  meta = with lib;{
    homepage =  http://plugins.jquery.com/project/jQuery-File-Upload;
    description = "jquery-file-upload packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
