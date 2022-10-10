{ lib
, buildPythonPackage
, fetchzip
, fetchFromGitHub
, black
, coverage
, pre-commit
, pylint
, faiss
, numpy
, pyyaml
, torch
, transformers
, unittest2
, aiohttp
, fastapi
, uvicorn
, libcloud
, rich
, networkx
, python-louvain
, beautifulsoup4
, fasttext
, imagehash
, nltk
, onnx
, onnxmltools
, onnxruntime
, pandas
, pillow
, sentencepiece
, soundfile
, tika
, timm
, annoy
, hnswlib
, pymagnitute-lite
, scikit-learn
, sentence-transformers
, croniter
, openpyxl
, requests
, xmltodict
}:
let
  extras = {
    dev = [ black coverage pre-commit pylint ];
    api = [ aiohttp fastapi uvicorn ];
    cloud = [ libcloud ];
    console = [ rich ];
    graph = [ networkx python-louvain ];
    model = [ onnxruntime ];
    pipeline = [
      beautifulsoup4
      fasttext
      imagehash
      nltk
      onnx
      onnxmltools
      onnxruntime
      pandas
      pillow
      sentencepiece
      soundfile
      tika
      timm
    ];
    similarity = [
      annoy
      fasttext
      hnswlib
      pymagnitute-lite
      scikit-learn
      sentence-transformers
    ];
    workflow = [
      libcloud
      croniter
      openpyxl
      pandas
      pillow
      requests
      xmltodict

    ];
  };
in
buildPythonPackage rec {
  pname = "txtai";
  version = "5.0.0";
  src = fetchFromGitHub {
    owner = "neuml";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-h1SXh4eJGuVZ90mLERzJ1dWaXBaMfkZOwnm5vNb+2Tc=";
  };


  postPatch = ''
    substituteInPlace setup.py \
      --replace '"faiss-cpu>=1.7.1.post2"' '"faiss>=*"'
  '';

  propagatedBuildInputs = [ faiss numpy pyyaml torch transformers ];

  checkInputs = [ unittest2 ] ++ passthru.optional-dependencies.all;

  testData = fetchzip {
    url = "https://github.com/neuml/txtai/releases/download/v3.5.0/tests.tar.gz";
    hash = "sha256-+JFCh+LFlhiIpjPKQrObW/nAPYNPqs7KXhG8bzdY7vw=";
  };

  checkPhase = ''
    runHook preCheck

    substituteInPlace test/python/utils.py \
      --replace '/tmp/txtai' '${testData}'
    export TOKENIZERS_PARALLELISM=false

    python -m unittest discover -v -s test/python

     runHook postCheck
  '';

  # unittestFlags = [ "-v" "-sfsdafasd" "test/python" ];

  passthru.optional-dependencies = with builtins;
    extras // { all = concatLists (attrValues extras); };

  meta = with lib; {
    description = "Build AI-powered semantic search applications";
    homepage = "https://github.com/neuml/txtai";
    license = licenses.asl20;
    maintainers = with maintainers; [ ehllie ];
  };

}
