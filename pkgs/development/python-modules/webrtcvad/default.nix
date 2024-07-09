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
    sha256 = "f1bed2fb25b63fb7b1a55d64090c993c9c9167b28485ae0bcdd81cf6ede96aea";
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
