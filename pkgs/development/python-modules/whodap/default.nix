{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
<<<<<<< HEAD
  httpx,
  setuptools,
=======
  pythonOlder,
  httpx,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "whodap";
<<<<<<< HEAD
  version = "0.1.14";
  pyproject = true;
=======
  version = "0.1.13";
  format = "setuptools";

  disabled = pythonOlder "3.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pogzyb";
    repo = "whodap";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-VSFtHjdG9pJAryGUgwI0NxxaW0JiXEHU7aVvXYxymtc=";
  };

  build-system = [ setuptools ];

  dependencies = [ httpx ];
=======
    tag = version;
    hash = "sha256-VSFtHjdG9pJAryGUgwI0NxxaW0JiXEHU7aVvXYxymtc=";
  };

  propagatedBuildInputs = [ httpx ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_client.py"
  ];

  pythonImportsCheck = [ "whodap" ];

<<<<<<< HEAD
  meta = {
    description = "Python RDAP utility for querying and parsing information about domain names";
    homepage = "https://github.com/pogzyb/whodap";
    changelog = "https://github.com/pogzyb/whodap/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python RDAP utility for querying and parsing information about domain names";
    homepage = "https://github.com/pogzyb/whodap";
    changelog = "https://github.com/pogzyb/whodap/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
