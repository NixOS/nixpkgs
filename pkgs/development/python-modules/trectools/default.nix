{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beautifulsoup4,
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
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "joaopalotti";
    repo = "trectools";
    # https://github.com/joaopalotti/trectools/issues/41
    rev = "8a896def007e3d657eb29f820ee3de98e2f32691";
    hash = "sha256-p8BvLO+rD/l+ATE4+u3I6k25R1RVKlk2dn+RLQZTLDs=";
  };

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

  pythonRemoveDeps = [ "bs4" ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  preCheck = ''
    # tests pass numpy arrays to float(), which numpy 2 rejects
    rm unittests/testtreceval.py
  '';

  unittestFlags = [
    "unittests/"
  ];

  pythonImportsCheck = [ "trectools" ];

  meta = {
    homepage = "https://github.com/joaopalotti/trectools";
    description = "Library for assisting Information Retrieval (IR) practitioners with TREC-like campaigns";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ MoritzBoehme ];
  };
}
