{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
  xstatic-jquery,
}:

buildPythonPackage (finalAttrs: {
  pname = "xstatic-jquery-file-upload";
  version = "10.31.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "XStatic-jQuery-File-Upload";
    inherit (finalAttrs) version;
    hash = "sha256-fXFvJqyhRzLDXFTwum04GHYAq0cvyYqR2XLRLFpw2yc=";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  dependencies = [ xstatic-jquery ];

  pythonImportsCheck = [ "xstatic.pkg.jquery_file_upload" ];

  meta = {
    homepage = "https://github.com/blueimp/jQuery-File-Upload";
    description = "jquery-file-upload packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
})
