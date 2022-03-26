{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, attrs
, cattrs
, fonttools
, fs
, pytestCheckHook
, ufo2ft
, ufoLib2
}:

buildPythonPackage rec {
  pname = "statmake";
  version = "0.4.1";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "daltonmaag";
    repo = "statmake";
    rev = "v${version}";
    sha256 = "OXhoQAD4LEh80iRUZE2z8sCtWJDv/bSo0bwHbOOPVE0=";
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
      --replace 'build-backend = "poetry.masonry.api"' 'build-backend = "poetry.core.masonry.api"'
  '';

  meta = with lib; {
    description = "Applies STAT information from a Stylespace to a variable font";
    homepage = "https://github.com/daltonmaag/statmake";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
