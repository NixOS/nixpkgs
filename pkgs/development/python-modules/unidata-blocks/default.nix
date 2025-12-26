{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  nix-update-script,
  hatchling,
  langcodes,
}:

buildPythonPackage rec {
  pname = "unidata-blocks";
  version = "0.0.18";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "unidata_blocks";
    inherit version;
    hash = "sha256-ptmkFJKRXXPE+EE5sXR562rChzQr/WOWZoQno6EFQ8U=";
  };

  build-system = [ hatchling ];

  dependencies = [
    langcodes
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "unidata_blocks" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/unidata-blocks";
    description = "Library that helps query unicode blocks by Blocks.txt";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      TakWolf
      h7x4
    ];
  };
}
