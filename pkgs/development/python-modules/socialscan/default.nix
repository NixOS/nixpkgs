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
  version = "1.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iojw";
    repo = pname;
    rev = "v${version}";
    sha256 = "rT+/j6UqDOzuNBdN3I74YIxS6qkhd7BjHCGX+gGjprc=";
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
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
