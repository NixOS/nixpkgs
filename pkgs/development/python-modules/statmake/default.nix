{ lib
, attrs
, buildPythonPackage
, cattrs
, exceptiongroup
, fetchFromGitHub
, fonttools
, fs
, importlib-metadata
, poetry-core
, pytestCheckHook
, pythonOlder
, ufo2ft
, ufoLib2
}:

buildPythonPackage rec {
  pname = "statmake";
  version = "0.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "daltonmaag";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-BpxjAr65ZQEJ0PSUIPtS78UvJbMG91qkV8py2K/+W2E=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    attrs
    cattrs
    fonttools
    # required by fonttools[ufo]
    fs
  ] ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
    ufo2ft
    ufoLib2
  ];

  postPatch = ''
    # https://github.com/daltonmaag/statmake/pull/41
    substituteInPlace pyproject.toml \
      --replace 'requires = ["poetry>=1.0.0"]' 'requires = ["poetry-core"]' \
      --replace 'build-backend = "poetry.masonry.api"' 'build-backend = "poetry.core.masonry.api"' \
      --replace 'cattrs = "^1.1"' 'cattrs = ">= 1.1"'
  '';

  pythonImportsCheck = [
    "statmake"
  ];

  meta = with lib; {
    description = "Applies STAT information from a Stylespace to a variable font";
    homepage = "https://github.com/daltonmaag/statmake";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
