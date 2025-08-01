{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  imagemagickBig,
  py,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wand";
  version = "0.6.13";
  format = "setuptools";

  src = fetchPypi {
    pname = "Wand";
    inherit version;
    hash = "sha256-9QE0hOr3og6yLRghqu/mC1DMMpciNytfhWXUbUqq/Mo=";
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert wand.color.Color('srgb(255,0,1.41553e-14)') == wand.color.Color('srgb(255,0,0)')
    "test_sparse_color"
  ];

  passthru.imagemagick = imagemagickBig;

  meta = with lib; {
    changelog = "https://docs.wand-py.org/en/${version}/changes.html";
    description = "Ctypes-based simple MagickWand API binding for Python";
    homepage = "http://wand-py.org/";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
