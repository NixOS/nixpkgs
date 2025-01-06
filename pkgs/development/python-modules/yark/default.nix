{
  lib,
  buildPythonPackage,
  click,
  colorama,
  fetchPypi,
  flask,
  poetry-core,
  progress,
  pythonOlder,
  requests,
  yt-dlp,
}:

buildPythonPackage rec {
  pname = "yark";
  version = "1.2.12";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K66LC/HhajAMCWU7PPfxkoaK84kLlAccYAH5FXoc+yE=";
  };

  pythonRelaxDeps = [
    "flask"
    "requests"
    "yt-dlp"
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
    colorama
    flask
    progress
    requests
    yt-dlp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "yark" ];

  meta = with lib; {
    description = "Module for YouTube archiving";
    mainProgram = "yark";
    homepage = "https://github.com/Owez/yark";
    changelog = "https://github.com/Owez/yark/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
