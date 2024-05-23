{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "tinytag";
  version = "1.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devsnd";
    repo = "tinytag";
    rev = version;
    hash = "sha256-Kg67EwDIi/Io7KKnNiqPzQKginrfuE6FAeOCjFgEJkY=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  meta = with lib; {
    description = "Python library for reading audio file metadata, duration of MP3, OGG, OPUS, MP4, M4A, FLAC, WMA, Wave, AIFF and a few more";
    homepage = "https://github.com/devsnd/tinytag";
    license = licenses.mit;
    maintainers = with maintainers; [ daru-san ];
  };
}
