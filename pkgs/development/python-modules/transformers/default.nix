{ buildPythonPackage
, lib, stdenv
, fetchFromGitHub
, pythonOlder
, cookiecutter
, filelock
, importlib-metadata
, regex
, requests
, numpy
, protobuf
, sacremoses
, tokenizers
, tqdm
}:

buildPythonPackage rec {
  pname = "transformers";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yf5s878i6v298wxm4cwkb33qyxz5bdr75jmsnldpdw4ml31c3nn";
  };

  propagatedBuildInputs = [
    cookiecutter
    filelock
    numpy
    protobuf
    regex
    requests
    sacremoses
    tokenizers
    tqdm
  ] ++ stdenv.lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # Many tests require internet access.
  doCheck = false;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "tokenizers == 0.9.4" "tokenizers"
  '';

  pythonImportsCheck = [ "transformers" ];

  meta = with lib; {
    homepage = "https://github.com/huggingface/transformers";
    description = "State-of-the-art Natural Language Processing for TensorFlow 2.0 and PyTorch";
    changelog = "https://github.com/huggingface/transformers/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ danieldk pashashocky ];
  };
}
