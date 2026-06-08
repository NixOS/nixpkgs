{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "update-copyright";
  version = "0.6.2";
  pyproject = true;

  __structuredAttrs = true;

  disabled = !isPy3k;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "update-copyright";
    sha256 = "17ybdgbdc62yqhda4kfy1vcs1yzp78d91qfhj5zbvz1afvmvdk7z";
  };

  build-system = [
    setuptools
  ];

  # Has no tests
  doCheck = false;

  meta = {
    description = "Automatic copyright update tool";
    mainProgram = "update-copyright.py";
    homepage = "http://blog.tremily.us/posts/update-copyright";
    license = lib.licenses.gpl3Plus;
  };
})
