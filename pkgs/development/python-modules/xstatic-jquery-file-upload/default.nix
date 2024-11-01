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
    sha256 = "7d716f26aca14732c35c54f0ba6d38187600ab472fc98a91d972d12c5a70db27";
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
