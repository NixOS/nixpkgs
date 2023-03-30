{ buildPythonPackage
, python
, pytorch-bin
, librosa
, inflect
, tqdm
, unidecode
, tokenizers
, transformers
, einops
, progressbar
, torchaudio-bin
, rotary-embedding-torch
, lib
, fetchFromGitHub
}:

buildPythonPackage {
  pname = "tortoise-tts";
  version = "2.3.0";
  src = fetchFromGitHub {
    owner = "neonbjb";
    repo = "tortoise-tts";
    rev = "a9e64e216d871f52c091465f2a2a8e503737a69c";
    sha256 = "sha256-PrWNc6NN7lPoZqfif5XjpPo5q5O/vWo6EqtR9m5jkss=";
  };
  propagatedBuildInputs = [
    pytorch-bin
    librosa
    inflect
    tqdm
    unidecode
    tokenizers
    transformers
    einops
    progressbar
    torchaudio-bin
    rotary-embedding-torch
  ];
  pythonImportsCheck = [ "tortoise" "torch" ];
  doCheck = false;
  postInstall = ''
    mv $out/bin/tortoise_tts.py $out/bin/tortoise-tts
  '';

  meta = with lib; {
    homepage = "https://github.com/neonbjb/tortoise-tts";
    description = "A multi-voice TTS system trained with an emphasis on quality";
    license = licenses.asl20;
    maintainers = [ maintainers.ranfdev ];
  };
}
