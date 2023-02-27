{ lib
, fetchPypi
, python
, buildPythonPackage
, pythonOlder
, tqdm
, transformers
, torchaudio
, more-itertools
, ffmpeg-python
, openai-whisper
, numpy
}:

buildPythonPackage rec {
  pname = "stable-ts";
  version = "1.1.1b0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-0smPDsZROn+L4LaxfcwO9Mx3L5Kddp6+oJDNUv+E0Gw=";
  };

  propagatedBuildInputs = [
    tqdm
    transformers
    torchaudio
    more-itertools
    ffmpeg-python
    openai-whisper
    numpy
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "stable_whisper" ];

  meta = with lib; {
    description = "Modifies and adds more robust decoding logic on top of OpenAI's Whisper to produce more accurate segment-level timestamps and obtain to word-level timestamps with extra inference";
    homepage = "https://github.com/jianfch/stable-ts";
    license = licenses.mit;
    maintainers = with maintainers; [ FaustXVI ];
  };
}
