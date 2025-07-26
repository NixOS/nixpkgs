{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pytestCheckHook
, python-memcached }:

buildPythonPackage rec {
  pname = "uhashring";
  version = "2.3";
  pyproject = true;

  # Pypi source release is missing some files, so we use github release instead.
  src = fetchFromGitHub {
    owner =  "ultrabug";
    repo = pname;
    rev = version;
    hash = "sha256-q3yOEORurxHm/TRwNwWNPUPl97b/20z0Md962ezBjKU=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
    python-memcached
  ];
}
