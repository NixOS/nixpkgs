{ lib
, buildPythonPackage
, fetchFromGitHub
, beautifulsoup4
, pythonOlder
, pandas
, python
, numpy
, scikit-learn
, scipy
, lxml
, matplotlib
, sarge
}:

buildPythonPackage rec {
  pname = "trectools";
  version = "0.0.49";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "joaopalotti";
    repo = pname;
    # https://github.com/joaopalotti/trectools/issues/41
    rev = "5c1d56e9cf955f45b5a1780ee6a82744d31e7a79";
    hash = "sha256-Lh6sK2rxEdCsOUKHn1jgm+rsn8FK1f2po0UuZfZajBA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "bs4 >= 0.0.0.1" "beautifulsoup4 >= 4.11.1"
  '';

  propagatedBuildInputs = [
    pandas
    numpy
    scikit-learn
    scipy
    lxml
    beautifulsoup4
    matplotlib
    sarge
  ];

  checkPhase = ''
    cd unittests
    ${python.interpreter} -m unittest runner
  '';

  pythonImportsCheck = [ "trectools" ];

  meta = with lib; {
    homepage = "https://github.com/joaopalotti/trectools";
    description = "Library for assisting Information Retrieval (IR) practitioners with TREC-like campaigns";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ MoritzBoehme ];
  };
}
