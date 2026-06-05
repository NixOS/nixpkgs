{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  nix-update-script,
  uv-build,
  langcodes,
}:

buildPythonPackage rec {
  pname = "unidata-blocks";
  version = "0.0.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "unidata-blocks";
    tag = version;
    hash = "sha256-BWcKqTMYdJ59XncPL29wCms2kCVTrcrV1zSY8mkbErs=";
  };

  build-system = [ uv-build ];

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
