{
  lib,
  buildPythonPackage,
  internetarchive,
  fetchPypi,
  yt-dlp,
  docopt,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tubeup";
  version = "2023.9.19";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Pp4h0MBoYhczmxPq21cLiYpLUeFP+2JoACcFpBl3b0E=";
  };

  propagatedBuildInputs = [
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
