{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  imagemagickBig,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "wand";
  version = "0.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emcconville";
    repo = "wand";
    tag = version;
    hash = "sha256-1ZkvJxlv47rQ2BOBnEWPczcjIM2muywemrxwY2ZN2UA=";
  };

  patches = [
    # https://github.com/emcconville/wand/issues/691
    (fetchpatch {
      url = "https://github.com/emcconville/wand/commit/e194860e5264d8202d4ecb31002a001b3b386bd5.patch";
      excludes = [
        "pyproject.toml"
        "wand/version.py"
      ];
      hash = "sha256-BvoIlAatTNrvJoE6y7kiuh7yXaKneuIzBHSF3nuEZWs=";
    })
  ];

  postPatch = ''
    substituteInPlace wand/api.py --replace-fail \
      "magick_home = os.environ.get('MAGICK_HOME')" \
      "magick_home = '${imagemagickBig}'"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert wand.color.Color('srgb(255,0,1.41553e-14)') == wand.color.Color('srgb(255,0,0)')
    "test_sparse_color"
  ];

  passthru.imagemagick = imagemagickBig;

  meta = {
    changelog = "https://docs.wand-py.org/en/${version}/changes.html";
    description = "Ctypes-based simple MagickWand API binding for Python";
    homepage = "http://wand-py.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
