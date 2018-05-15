{ stdenv
, buildPythonPackage
, isPy27
, fetchPypi
, cachetools
, cld2-cffi
, cython
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
  name = "${pname}-${version}";
  pname = "textacy";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "32ffb796f2abf0577af480d482608cca2baf85d366a4e2981ffd3e632ebeb76c";
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

  doCheck = false;  # tests want to download data files

  meta = with stdenv.lib; {
    description = "Higher-level text processing, built on spaCy";
    homepage = "http://textacy.readthedocs.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvl ];
  };
}
