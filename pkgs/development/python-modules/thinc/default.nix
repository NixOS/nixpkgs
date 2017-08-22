{ stdenv
, pkgs
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, pytest
, cython
, cymem
, preshed
, numpy
, python
, murmurhash
, hypothesis
, tqdm
, cytoolz
, plac
, six
, mock
, termcolor
, wrapt
, dill
}:

let
  enableDebugging = true;

  pathlibLocked = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "pathlib";
    version = "1.0.1";

    src = fetchPypi {
      inherit pname version;      
      sha256 = "17zajiw4mjbkkv6ahp3xf025qglkj0805m9s41c45zryzj6p2h39";
    };

    doCheck = false; # fails to import support from test
  };
in buildPythonPackage rec {
  name = "thinc-${version}";
  version = "6.5.1";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "thinc";
    rev = "v${version}";
    sha256 = "008kmjsvanh6qgnpvsn3qacfcyprxirxbw4yfd8flyg7mxw793ws";    
  };

  propagatedBuildInputs = [
   cython
   cymem
   preshed
   numpy
   murmurhash
   pytest
   hypothesis
   tqdm
   cytoolz
   plac
   six
   mock
   termcolor
   wrapt
   dill
   pathlibLocked
  ];

  doCheck = false;
  
  # fails to import some modules
  # checkPhase = ''
  #   ${python.interpreter} -m pytest thinc/tests
  #   # cd thinc/tests
  #   # ${python.interpreter} -m unittest discover -p "*test*"
  # '';
  
  meta = with stdenv.lib; {
    description = "Practical Machine Learning for NLP in Python";
    homepage = https://github.com/explosion/thinc;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];
    };
}
