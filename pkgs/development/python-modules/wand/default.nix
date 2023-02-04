{ lib
, buildPythonPackage
, fetchPypi
, imagemagickBig
, py
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wand";
  version = "0.6.10";

  src = fetchPypi {
    pname = "Wand";
    inherit version;
    sha256 = "sha256-Nz9KfyhmyGjDHOkQ4fmzapLRMmQKIAaOwXzqMoT+3Fc=";
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
    description = "Ctypes-based simple MagickWand API binding for Python";
    homepage = "http://wand-py.org/";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ infinisil ];
  };
}
