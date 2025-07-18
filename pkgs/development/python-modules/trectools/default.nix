{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beautifulsoup4,
  pythonOlder,
  pandas,
  python,
  numpy,
  scikit-learn,
  scipy,
  lxml,
  matplotlib,
  sarge,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage {
  pname = "trectools";
  version = "0.0.50";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "joaopalotti";
    repo = "trectools";
    # https://github.com/joaopalotti/trectools/issues/41
    rev = "8a896def007e3d657eb29f820ee3de98e2f32691";
    hash = "sha256-p8BvLO+rD/l+ATE4+u3I6k25R1RVKlk2dn+RLQZTLDs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "bs4 >= 0.0.0.1" "beautifulsoup4 >= 4.11.1"
  '';

  build-system = [ setuptools ];

  dependencies = [
    pandas
    numpy
    scikit-learn
    scipy
    lxml
    beautifulsoup4
    matplotlib
    sarge
  ];

  unittestFlagsArray = [
    "unittests/"
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "trectools" ];

  meta = {
    homepage = "https://github.com/joaopalotti/trectools";
    description = "Library for assisting Information Retrieval (IR) practitioners with TREC-like campaigns";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ MoritzBoehme ];
  };
}
