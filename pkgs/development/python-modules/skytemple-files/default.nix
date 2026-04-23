{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # buildInputs
  armips,

  # dependencies
  appdirs,
  dungeon-eos,
  explorerscript,
  ndspy,
  pillow,
  pmdsky-debug-py,
  pyyaml,
  range-typed-integers,
  skytemple-rust,

  # optional-dependencies
  aiohttp,
  gql,
  graphql-core,
  lru-dict,

  # tests
  parameterized,
  pytestCheckHook,
  xmldiff,
}:

buildPythonPackage (finalAttrs: {
  pname = "skytemple-files";
  version = "1.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "skytemple-files";
    tag = finalAttrs.version;
    # Most patches are in submodules
    fetchSubmodules = true;
    hash = "sha256-s7r6wS7H19+is3CFr+dLaTiq0N/gaO/8IFknmr+OAJk=";
  };

  postPatch = ''
    substituteInPlace \
      skytemple_files/patch/arm_patcher.py \
      skytemple_files/data/data_cd/armips_importer.py \
      --replace-fail \
        "exec_name = os.getenv(\"SKYTEMPLE_ARMIPS_EXEC\", f\"{prefix}armips\")" \
        "exec_name = \"${armips}/bin/armips\""
  '';

  build-system = [ setuptools ];

  buildInputs = [ armips ];

  pythonRelaxDeps = [
    "pmdsky-debug-py"
  ];
  dependencies = [
    appdirs
    dungeon-eos
    explorerscript
    ndspy
    pillow
    pmdsky-debug-py
    pyyaml
    range-typed-integers
    skytemple-rust
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
    parameterized
    pytestCheckHook
    xmldiff
  ]
  ++ finalAttrs.passthru.optional-dependencies.spritecollab;

  preCheck = "pushd test";
  postCheck = "popd";

  disabledTestPaths = [
    "skytemple_files_test/common/spritecollab/sc_online_test.py"
    "skytemple_files_test/compression_container/atupx/atupx_test.py" # Particularly long test
  ];

  pythonImportsCheck = [ "skytemple_files" ];

  meta = {
    description = "Python library to edit the ROM of Pokémon Mystery Dungeon Explorers of Sky";
    homepage = "https://github.com/SkyTemple/skytemple-files";
    mainProgram = "skytemple_export_maps";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ marius851000 ];
    badPlatforms = [
      # pyobjc is missing
      lib.systems.inspect.patterns.isDarwin
    ];
  };
})
