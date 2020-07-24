{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, blis
, catalogue
, cymem
, jsonschema
, murmurhash
, numpy
, pathlib
, plac
, preshed
, requests
, setuptools
, srsly
, thinc
, wasabi
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07zf7kivj4r1n6xwisld7n90bpi095bqbc9xpv668grq1rpf53c1";
  };

  propagatedBuildInputs = [
   blis
   catalogue
   cymem
   jsonschema
   murmurhash
   numpy
   plac
   preshed
   requests
   setuptools
   srsly
   thinc
   wasabi
  ] ++ lib.optional (pythonOlder "3.4") pathlib;

  checkInputs = [
    pytest
  ];

  doCheck = false;
  # checkPhase = ''
  #   ${python.interpreter} -m pytest spacy/tests --vectors --models --slow
  # '';

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "catalogue>=0.0.7,<1.1.0" "catalogue>=0.0.7,<3.0" \
      --replace "plac>=0.9.6,<1.2.0" "plac>=0.9.6,<2.0" \
      --replace "srsly>=1.0.2,<1.1.0" "srsly>=1.0.2,<3.0" \
      --replace "thinc==7.4.1" "thinc>=7.4.1,<8"
  '';

  pythonImportsCheck = [ "spacy" ];

  meta = with lib; {
    description = "Industrial-strength Natural Language Processing (NLP) with Python and Cython";
    homepage = "https://github.com/explosion/spaCy";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk sdll ];
  };
}
