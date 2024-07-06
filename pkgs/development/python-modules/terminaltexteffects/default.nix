{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "terminaltexteffects";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ChrisBuilds";
    repo = "terminaltexteffects";
    rev = "refs/tags/release-${version}";
    hash = "sha256-4stpAFCNgE5gWBkL4Unpai2Lq7hnQPZSshy5vo7AU1E=";
  };

  build-system = [ poetry-core ];

  doCheck = false;

  pythonImportsCheck = [ "terminaltexteffects" ];

  meta = with lib; {
    description = "A collection of visual effects that can be applied to terminal piped stdin text";
    homepage = "https://chrisbuilds.github.io/terminaltexteffects";
    changelog = "https://chrisbuilds.github.io/terminaltexteffects/changeblog/";
    license = licenses.mit;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ qwqawawow ];
    mainProgram = "tte";
  };
}
