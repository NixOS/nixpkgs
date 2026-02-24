{
  lib,
  buildPythonPackage,
  setuptools,
  internetarchive,
  fetchPypi,
  yt-dlp,
  docopt,
}:

buildPythonPackage rec {
  pname = "tubeup";
  version = "2026.2.19";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aC8kWOE4oXyeCBfbgDuzC+l/IfpZfuTcFdUt1KXJ0lA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    internetarchive
    docopt
    yt-dlp
  ];

  pythonRelaxDeps = [ "docopt" ];

  pythonImportsCheck = [ "tubeup" ];

  # Tests failing upstream
  doCheck = false;

  meta = {
    description = "Youtube (and other video site) to Internet Archive Uploader";
    mainProgram = "tubeup";
    homepage = "https://github.com/bibanon/tubeup";
    changelog = "https://github.com/bibanon/tubeup/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
