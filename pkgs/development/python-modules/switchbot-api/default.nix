{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "switchbot-api";
<<<<<<< HEAD
  version = "2.9.0";
  pyproject = true;

=======
  version = "2.8.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "SeraphicCorp";
    repo = "py-switchbot-api";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-G5cUpX89KC6C4295wbvyeYWvUob4LdHiJjcN0UbVJnY=";
=======
    hash = "sha256-xalIVkmzflUVkw/DFOLas6T/jUXSs3gZhEa3IJWtEaw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "switchbot_api" ];

<<<<<<< HEAD
  meta = {
    description = "Asynchronous library to use Switchbot API";
    homepage = "https://github.com/SeraphicCorp/py-switchbot-api";
    changelog = "https://github.com/SeraphicCorp/py-switchbot-api/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Asynchronous library to use Switchbot API";
    homepage = "https://github.com/SeraphicCorp/py-switchbot-api";
    changelog = "https://github.com/SeraphicCorp/py-switchbot-api/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
