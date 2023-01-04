{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, colorama
, pythonOlder
, tqdm
}:

buildPythonPackage rec {
  pname = "socialscan";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iojw";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-jiyTcpJ00DvfweChawj1ugdCVHHAdwDbHEp9jivH7gs=";
  };

  propagatedBuildInputs = [
    aiohttp
    colorama
    tqdm
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "socialscan"
  ];

  meta = with lib; {
    description = "Python library and CLI for accurately querying username and email usage on online platforms";
    homepage = "https://github.com/iojw/socialscan";
    changelog = "https://github.com/iojw/socialscan/releases/tag/v${version}";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
