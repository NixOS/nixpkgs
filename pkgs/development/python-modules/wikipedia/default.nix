{
  lib,
  buildPythonPackage,
  fetchPypi,
  beautifulsoup4,
  requests,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "wikipedia";
  version = "1.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2w+tGCn91EGxhSMG6YVjmCBNwHhtKZbdLgyLuOJhM7I=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    requests
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "tests/ '*test.py'" ];

  meta = {
    description = "Pythonic wrapper for the Wikipedia API";
    homepage = "https://github.com/goldsmith/Wikipedia";
    changelog = "https://github.com/goldsmith/Wikipedia/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
