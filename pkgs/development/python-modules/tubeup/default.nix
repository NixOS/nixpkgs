{
  lib,
  buildPythonPackage,
  setuptools,
  internetarchive,
  fetchPypi,
  yt-dlp,
  docopt,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tubeup";
  version = "2025.3.14";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zdqiUKnm+E0evo+MOEAaFK38FaWcY3LDrnatyZoX5bc=";
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

  meta = with lib; {
    description = "Youtube (and other video site) to Internet Archive Uploader";
    mainProgram = "tubeup";
    homepage = "https://github.com/bibanon/tubeup";
    changelog = "https://github.com/bibanon/tubeup/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = [ ];
  };
}
