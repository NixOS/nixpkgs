{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "webrtcvad";
  version = "2.0.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8b7S+yW2P7expV1kCQyZPJyRZ7KEha4Lzdgc9u3pauo=";
  };

  # required WAV files for testing are not included in the tarball
  doCheck = false;

  meta = {
    description = "Interface to the Google WebRTC Voice Activity Detector (VAD)";
    homepage = "https://github.com/wiseman/py-webrtcvad";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
