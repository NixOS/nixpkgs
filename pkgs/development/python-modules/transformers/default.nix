{ buildPythonPackage
, stdenv
, fetchFromGitHub
, sacremoses
, requests
, sentencepiece
, boto3
, tqdm
, regex
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "transformers";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "v${version}";
    sha256 = "1p8p3lhhiyk1xl9gpgq4vbchyz57v3w7hhvsj1r90zs3cckindl8";
  };

  propagatedBuildInputs = [ numpy sacremoses requests sentencepiece boto3 tqdm regex ];

  checkInputs = [ pytest ];
  # pretrained tries to download from s3
  checkPhase = ''
    cd transformers # avoid importing local files
    HOME=$TMPDIR pytest -k 'not pretrained_tokenizers'
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/huggingface/transformers";
    description = "State-of-the-art Natural Language Processing for TensorFlow 2.0 and PyTorch";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ pashashocky ];
  };
}
