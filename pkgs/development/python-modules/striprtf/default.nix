{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.35";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oh6MT3OnkcPyNWHflnAUiMaRqxdJqSSHzJ5f7m6ghFU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'hatchling>=1.21.0,<1.32' hatchling
  '';

  build-system = [ hatchling ];

  pythonImportsCheck = [ "striprtf" ];

  meta = {
    changelog = "https://github.com/joshy/striprtf/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/joshy/striprtf";
    description = "Simple library to convert rtf to text";
    mainProgram = "striprtf";
    maintainers = with lib.maintainers; [ aanderse ];
    license = lib.licenses.bsd3;
  };
}
