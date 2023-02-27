{ lib
, buildPythonPackage
, fetchPypi
, imagemagickBig
, py
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wand";
  version = "0.6.11";

  src = fetchPypi {
    pname = "Wand";
    inherit version;
    sha256 = "sha256-tmFwDan48ekx5Scm5PxkOlZblRT1iD1Bt3Pjw3yfqZU=";
  };

  postPatch = ''
    substituteInPlace wand/api.py --replace \
      "magick_home = os.environ.get('MAGICK_HOME')" \
      "magick_home = '${imagemagickBig}'"
  '';

  nativeCheckInputs = [
    py
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/emcconville/wand/issues/558
    "test_forward_fourier_transform"
    "test_inverse_fourier_transform"
    # our imagemagick doesn't set MagickReleaseDate
    "test_configure_options"
  ];

  passthru.imagemagick = imagemagickBig;

  meta = with lib; {
    changelog = "https://docs.wand-py.org/en/${version}/changes.html";
    description = "Ctypes-based simple MagickWand API binding for Python";
    homepage = "http://wand-py.org/";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ infinisil dotlambda ];
  };
}
