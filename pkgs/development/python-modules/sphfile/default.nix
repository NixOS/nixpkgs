{
  lib,
  fetchurl,
  buildPythonPackage,
  numpy,
}:

buildPythonPackage rec {
  pname = "sphfile";
  version = "1.0.3";
  format = "setuptools";

  src = fetchurl {
    url = "mirror://pypi/s/sphfile/${pname}-${version}.tar.gz";
    hash = "sha256-FZbYAfrMKwOkChvGeoOXAfBopBWXBZ/rgvyTeEIMUsA=";
  };

  propagatedBuildInputs = [ numpy ];

  doCheck = false;

  meta = with lib; {
    description = "Numpy-based NIST SPH audio-file reader";
    homepage = "https://github.com/mcfletch/sphfile";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
