{ buildPythonPackage
, lib
, fetchPypi
, xstatic-jquery
}:

buildPythonPackage rec {
  pname = "XStatic-jQuery-File-Upload";
  version = "9.22.0.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0jy7xnww0177fv0asssxvv8l1032jcnbkvz39z16yd6k34v53fzf";
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
