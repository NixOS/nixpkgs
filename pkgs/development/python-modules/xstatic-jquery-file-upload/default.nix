{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools_80,
  xstatic-jquery,
}:

buildPythonPackage (finalAttrs: {
  pname = "xstatic-jquery-file-upload";
  version = "10.32.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "XStatic-jQuery-File-Upload";
    inherit (finalAttrs) version;
    hash = "sha256-3p/FoprrGViy9x9iao7ooZ/YELl8AtEOnEis0rFyoEc=";
  };

  build-system = [ setuptools_80 ];

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
