{
  lib,
  buildPythonPackage,
  setuptools,
  internetarchive,
  fetchPypi,
  yt-dlp,
  docopt,
}:

buildPythonPackage (finalAttrs: {
  pname = "tubeup";
  version = "2025.5.11";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-LZ/kNtw5Tw3PtqQp4Dq2qOeXgofID5upFvpLMXUIuiM=";
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
    changelog = "https://github.com/bibanon/tubeup/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
})
