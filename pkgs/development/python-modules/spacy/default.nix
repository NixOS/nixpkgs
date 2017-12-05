{ stdenv
, pkgs
, buildPythonPackage
, python
, fetchPypi
, fetchFromGitHub
, pytest 
, cython
, cymem
, preshed
, pathlib2
, numpy
, murmurhash
, plac
, six
, ujson
, dill
, requests
, ftfy
, thinc
, pip
}:
let
  enableDebugging = true;
  regexLocked = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "regex";
    version = "2017.04.05";

    src = fetchPypi {
      inherit pname version;      
      sha256 = "0c95gf3jzz8mv52lkgq0h7sbasjwvdhghm4s0phmy5k9sr78f4fq";
    };
  };
in buildPythonPackage rec {
  name = "spacy-${version}";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "spaCy";
    rev = "v${version}";
    sha256 = "0v3bmmar31a6968y4wl0lmgnc3829l2mnwd8s959m4pqw1y1w648";    
  };  

  propagatedBuildInputs = [
   cython
   cymem
   pathlib2
   preshed
   numpy
   murmurhash
   plac
   six
   ujson
   dill
   requests
   regexLocked
   ftfy
   thinc
   pytest
   pip
  ];

  doCheck = false;
  # checkPhase = ''
  #   ${python.interpreter} -m pytest spacy/tests --vectors --models --slow
  # '';  
  
  meta = with stdenv.lib; {
    description = "Industrial-strength Natural Language Processing (NLP) with Python and Cython";
    homepage = https://github.com/explosion/spaCy;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];
    };
}
