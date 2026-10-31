{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "strict-rfc3339";
  version = "0.7";

  __structuredAttrs = true;
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-XK0Xvt/Dr1ezmdsP7TJ3Hxj8VLvZF+hVRgiGB6xeEnc=";
  };

  build-system = [ setuptools ];

  doCheck = false; # no test in archive

  meta = {
    homepage = "https://github.com/danielrichman/strict-rfc3339";
    license = lib.licenses.gpl3Plus;
    description = "Strict, simple, lightweight RFC3339 functions";
    maintainers = with lib.maintainers; [ vanschelven ];
  };
})
