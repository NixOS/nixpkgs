{ lib
, buildPythonPackage
, fetchFromGitHub
, gitpython
, click
, ordered-set
, pythonOlder
, pillow
, sortedcollections
}:

buildPythonPackage rec {
  pname = "tilequant";
  version = "0.4.1.post0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    hash = "sha256-7vU/AYnX7deOH3PjrseRIj9BUJMWzDlwR3UcMpBRyfc=";
    fetchSubmodules = true;
  };

  buildInputs = [
    gitpython
  ];

  propagatedBuildInputs = [
    click
    ordered-set
    pillow
    sortedcollections
  ];

  doCheck = false; # there are no tests

  pythonImportsCheck = [
    "skytemple_tilequant"
  ];

  meta = with lib; {
    description = "Tool for quantizing image colors using tile-based palette restrictions";
    homepage = "https://github.com/SkyTemple/tilequant";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 xfix ];
  };
}
