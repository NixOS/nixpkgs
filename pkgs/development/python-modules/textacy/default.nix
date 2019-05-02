{ stdenv
, buildPythonPackage
, isPy27
, fetchPypi
, cachetools
, cld2-cffi
, cytoolz
, ftfy
, ijson
, matplotlib
, networkx
, numpy
, pyemd
, pyphen
, python-Levenshtein
, requests
, scikitlearn
, scipy
, spacy
, tqdm
, unidecode
}:

buildPythonPackage rec {
  pname = "textacy";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "50402545ac92b1a931c2365e341cb35c4ebe5575525f1dcc5265901ff3895a5f";
  };

  disabled = isPy27; # 2.7 requires backports.csv

  propagatedBuildInputs = [
    cachetools
    cld2-cffi
    cytoolz
    ftfy
    ijson
    matplotlib
    networkx
    numpy
    pyemd
    pyphen
    python-Levenshtein
    requests
    scikitlearn
    scipy
    spacy
    tqdm
    unidecode
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'ftfy>=4.2.0,<5.0.0'," "'ftfy>=5.0.0',"
  '';

  doCheck = false;  # tests want to download data files

  meta = with stdenv.lib; {
    description = "Higher-level text processing, built on spaCy";
    homepage = "http://textacy.readthedocs.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvl ];
  };
}
