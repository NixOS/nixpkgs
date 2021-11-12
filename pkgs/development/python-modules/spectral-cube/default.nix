{ lib
, fetchPypi
, fetchpatch
, buildPythonPackage
, aplpy
, joblib
, astropy
, radio_beam
, six
, dask
, pytestCheckHook
, pytest-astropy
, astropy-helpers
}:

buildPythonPackage rec {
  pname = "spectral-cube";
  version = "0.5.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17zisr26syfb8kn89xj17lrdycm0hsmy5yp5zrn236wgd8rjriki";
  };

  patches = [
    # Fix compatibility with radio_beam >= 0.3.3. Will be included
    # in the next release of spectral cube > 0.5.0
    (fetchpatch {
      url = "https://github.com/radio-astro-tools/spectral-cube/commit/bbe4295ebef7dfa6fe4474275a29acd6cb0cb544.patch";
    sha256 = "1qddfm3364kc34yf6wd9nd6rxh4qc2v5pqilvz9adwb4a50z28bf";
    })
  ];

  nativeBuildInputs = [ astropy-helpers ];
  propagatedBuildInputs = [ astropy radio_beam joblib six dask ];
  checkInputs = [ pytestCheckHook aplpy pytest-astropy ];

  meta = {
    description = "Library for reading and analyzing astrophysical spectral data cubes";
    homepage = "http://radio-astro-tools.github.io";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ smaret ];
  };
}

