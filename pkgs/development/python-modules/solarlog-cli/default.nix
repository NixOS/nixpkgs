{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  bcrypt,
  mashumaro,
  aioresponses,
  pytest-aio,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "solarlog-cli";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "dontinelli";
    repo = "solarlog_cli";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-mO/EPJ/CF3FM1tPnQOT9vit6WjV+jsWrTQ1MH2UUIIc=";
=======
    hash = "sha256-oxeZkf5RpTgAd/PO8itElvQyBOQg1k4W//4M8Q0xbJg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    bcrypt
    mashumaro
  ];

  pythonImportsCheck = [ "solarlog_cli" ];

  nativeCheckInputs = [
    aioresponses
    pytest-aio
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/dontinelli/solarlog_cli/releases/tag/v${version}";
    description = "Python library to access the Solar-Log JSON interface";
    homepage = "https://github.com/dontinelli/solarlog_cli";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
