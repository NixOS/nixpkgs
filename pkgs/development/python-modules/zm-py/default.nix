{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "zm-py";
  version = "0.5.4";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "rohankapoorcom";
    repo = "zm-py";
    tag = "v${version}";
    hash = "sha256-n9FRX2Pnn96H0HVT4SHLJgONc0XzQ005itMNpvl9IYg=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "zoneminder" ];

<<<<<<< HEAD
  meta = {
    description = "Loose python wrapper around the ZoneMinder REST API";
    homepage = "https://github.com/rohankapoorcom/zm-py";
    changelog = "https://github.com/rohankapoorcom/zm-py/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ peterhoeg ];
=======
  meta = with lib; {
    description = "Loose python wrapper around the ZoneMinder REST API";
    homepage = "https://github.com/rohankapoorcom/zm-py";
    changelog = "https://github.com/rohankapoorcom/zm-py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
