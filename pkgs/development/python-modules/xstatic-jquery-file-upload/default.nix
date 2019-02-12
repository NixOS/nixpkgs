{ buildPythonPackage
, lib
, fetchPypi
, xstatic-jquery
}:

buildPythonPackage rec {
  pname = "XStatic-jQuery-File-Upload";
  version = "9.23.0.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "649a500870b5f5d9cc71d1c1dc4c4d2242f459b02d811a771336217e4e91bfda";
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
