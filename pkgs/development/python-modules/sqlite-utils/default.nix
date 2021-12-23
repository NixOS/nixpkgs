{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, click
, click-default-group
, dateutils
, sqlite-fts4
, tabulate
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "sqlite-utils";
  version = "3.19";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "509099fce5f25faada6e76b6fb90e8ef5ba0f1715177933a816718be0c8e7244";
  };

  patches = [
    # https://github.com/simonw/sqlite-utils/pull/347
    (fetchpatch {
      name = "sqlite-utils-better-test_rebuild_fts.patch";
      url = "https://github.com/simonw/sqlite-utils/pull/347/commits/1a7ef2fe2064ace01d5535fb771f941296fb642a.diff";
      sha256 = "sha256-WKCQGMqr8WYjG7cmAH5pYBhgikowbt3r6hObwtMDDUY=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  propagatedBuildInputs = [
    click
    click-default-group
    dateutils
    sqlite-fts4
    tabulate
  ];

  checkInputs = [
    pytestCheckHook
    hypothesis
  ];

  meta = with lib; {
    description = "Python CLI utility and library for manipulating SQLite databases";
    homepage = "https://github.com/simonw/sqlite-utils";
    license = licenses.asl20;
    maintainers = with maintainers; [ meatcar ];
  };
}
