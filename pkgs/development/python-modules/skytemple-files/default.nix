{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  appdirs,
  dungeon-eos,
  explorerscript,
  ndspy,
  pillow,
  setuptools,
  skytemple-rust,
  pyyaml,
  pmdsky-debug-py,
  range-typed-integers,
  pythonOlder,
  # optional dependencies for SpriteCollab
  aiohttp,
  lru-dict,
  graphql-core,
  gql,
  armips,
  # tests
  pytestCheckHook,
  parameterized,
  xmldiff,
}:

buildPythonPackage rec {
  pname = "skytemple-files";
  version = "1.8.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "skytemple-files";
    rev = version;
    hash = "sha256-s7r6wS7H19+is3CFr+dLaTiq0N/gaO/8IFknmr+OAJk=";
    # Most patches are in submodules
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace skytemple_files/patch/arm_patcher.py skytemple_files/data/data_cd/armips_importer.py \
      --replace-fail "exec_name = os.getenv(\"SKYTEMPLE_ARMIPS_EXEC\", f\"{prefix}armips\")" "exec_name = \"${armips}/bin/armips\""
  '';

  build-system = [ setuptools ];

  buildInputs = [ armips ];

  dependencies = [
    appdirs
    dungeon-eos
    explorerscript
    ndspy
    pillow
    skytemple-rust
    pyyaml
    pmdsky-debug-py
    range-typed-integers
  ];

  optional-dependencies = {
    spritecollab = [
      aiohttp
      gql
      graphql-core
      lru-dict
    ]
    ++ gql.optional-dependencies.aiohttp;
  };

  nativeCheckInputs = [
    pytestCheckHook
    parameterized
    xmldiff
  ]
  ++ optional-dependencies.spritecollab;

  preCheck = "pushd test";
  postCheck = "popd";

  disabledTestPaths = [
    "skytemple_files_test/common/spritecollab/sc_online_test.py"
    "skytemple_files_test/compression_container/atupx/atupx_test.py" # Particularly long test
  ];

  pythonImportsCheck = [ "skytemple_files" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-files";
    description = "Python library to edit the ROM of Pokémon Mystery Dungeon Explorers of Sky";
    mainProgram = "skytemple_export_maps";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 ];
    broken = stdenv.hostPlatform.isDarwin; # pyobjc is missing
  };
}
