{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, regex
, wcwidth
}:

buildPythonPackage rec {
  pname = "wikitextparser";
  version = "0.54.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "5j9";
    repo = "wikitextparser";
    rev = "v${version}";
    hash = "sha256-AGQfjUNxeleuTS200QMdZS8CSD2t4ah5NMm9TIYjVHk=";
  };

  propagatedBuildInputs = [
    wcwidth
    regex
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "wikitextparser" ];

  meta = {
    homepage = "https://github.com/5j9/wikitextparser";
    description = "A simple parsing tool for MediaWiki's wikitext markup";
    changelog = "https://github.com/5j9/wikitextparser/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rapiteanu ];
  };
}
