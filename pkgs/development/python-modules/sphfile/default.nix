{
  lib,
  fetchurl,
  buildPythonPackage,
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphfile";
  version = "1.0.3";
  format = "setuptools";

  src = fetchurl {
    url = "mirror://pypi/s/sphfile/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-FZbYAfrMKwOkChvGeoOXAfBopBWXBZ/rgvyTeEIMUsA=";
  };

  propagatedBuildInputs = [ numpy ];

  doCheck = false;

  meta = {
    description = "Numpy-based NIST SPH audio-file reader";
    homepage = "https://github.com/mcfletch/sphfile";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
