{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  click,
  click-default-group,
  python-dateutil,
  sqlite-fts4,
  tabulate,
  pluggy,
  pytestCheckHook,
  hypothesis,
  testers,
  sqlite-utils,
}:

buildPythonPackage rec {
  pname = "sqlite-utils";
  version = "3.37";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "sqlite-utils";
    rev = version;
    hash = "sha256-M6PbP4/HRw9EfCtZl4zzQjE7Blcs/Icpw2aSe8f0ZTs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "click-default-group-wheel" "click-default-group"
  '';

  propagatedBuildInputs = [
    click
    click-default-group
    python-dateutil
    sqlite-fts4
    tabulate
    pluggy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "sqlite_utils" ];

  passthru.tests.version = testers.testVersion { package = sqlite-utils; };

  meta = with lib; {
    description = "Python CLI utility and library for manipulating SQLite databases";
    mainProgram = "sqlite-utils";
    homepage = "https://github.com/simonw/sqlite-utils";
    changelog = "https://github.com/simonw/sqlite-utils/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      meatcar
      techknowlogick
    ];
  };
}
