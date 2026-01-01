{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  colorama,
  pythonOlder,
  tqdm,
}:

buildPythonPackage rec {
  pname = "socialscan";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iojw";
    repo = "socialscan";
    tag = "v${version}";
    hash = "sha256-4JJVhB6x1NGagtfzE03Jae2GOr25hh+4l7gQ23zc7Ck=";
  };

  propagatedBuildInputs = [
    aiohttp
    colorama
    tqdm
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "socialscan" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python library and CLI for accurately querying username and email usage on online platforms";
    mainProgram = "socialscan";
    homepage = "https://github.com/iojw/socialscan";
    changelog = "https://github.com/iojw/socialscan/releases/tag/v${version}";
<<<<<<< HEAD
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ fab ];
=======
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
