{
  buildPythonPackage,
  lib,
  fetchPypi,
  xstatic-jquery,
}:

buildPythonPackage rec {
  pname = "xstatic-jquery-file-upload";
  version = "10.31.0.1";

  src = fetchPypi {
    pname = "XStatic-jQuery-File-Upload";
    inherit version;
    hash = "sha256-fXFvJqyhRzLDXFTwum04GHYAq0cvyYqR2XLRLFpw2yc=";
  };

  # no tests implemented
  doCheck = false;

  propagatedBuildInputs = [ xstatic-jquery ];

  meta = with lib; {
    homepage = "https://plugins.jquery.com/project/jQuery-File-Upload";
    description = "jquery-file-upload packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
