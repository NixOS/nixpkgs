{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, fetchpatch
, matplotlib
, mock
, numpy
, pillow
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wordcloud";
  version = "1.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "amueller";
    repo = pname;
    rev = version;
    hash = "sha256-4EFQfv+Jn9EngUAyDoJP0yv9zr9Tnbrdwq1YzDacB9Q=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pillow
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  patches = [
    (fetchpatch {
      # https://github.com/amueller/word_cloud/pull/616
      url = "https://github.com/amueller/word_cloud/commit/858a8ac4b5b08494c1d25d9e0b35dd995151a1e5.patch";
      sha256 = "sha256-+aDTMPtOibVwjPrRLxel0y4JFD5ERB2bmJi4zRf/asg=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov --cov-report xml --tb=short" ""
  '';

  preCheck = ''
    cd test
  '';

  pythonImportsCheck = [
    "wordcloud"
  ];

  disabledTests = [
    # Don't tests CLI
    "test_cli_as_executable"
  ];

  meta = with lib; {
    description = "Word cloud generator in Python";
    homepage = "https://github.com/amueller/word_cloud";
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
  };
}
