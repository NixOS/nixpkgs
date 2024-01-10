{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, nix-update-script
, hatch-vcs
, hatchling
, langcodes
}:

buildPythonPackage rec {
  pname = "unidata-blocks";
  version = "0.0.9";

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "unidata_blocks";
    inherit version;
    hash = "sha256-OuIhajgUyO5qdcxJCO06Q1xNbeSNGzlbaWnAqXORm9g=";
  };

  format = "pyproject";

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [ langcodes ];

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/unidata-blocks";
    description = "A library that helps query unicode blocks by Blocks.txt";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ h7x4 ];
  };
}
