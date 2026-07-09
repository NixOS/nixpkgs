{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "webrtcvad";
  version = "2.0.10";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-8b7S+yW2P7expV1kCQyZPJyRZ7KEha4Lzdgc9u3pauo=";
  };

  patches = [
    # remove pkg_resources usage
    # backport of https://github.com/wiseman/py-webrtcvad/pull/96
    ./no-pkg-resources.patch
  ];

  build-system = [ setuptools ];

  # required WAV files for testing are not included in the tarball
  doCheck = false;

  pythonImportsCheck = [ "webrtcvad" ];

  meta = {
    description = "Interface to the Google WebRTC Voice Activity Detector (VAD)";
    homepage = "https://github.com/wiseman/py-webrtcvad";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
})
