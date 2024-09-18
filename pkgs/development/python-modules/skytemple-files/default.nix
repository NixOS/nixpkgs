{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
  # optional dependancies for SpriteCollab
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
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "skytemple-files";
    rev = version;
    hash = "sha256-G2AAQ+eRnsMTWrAF0SNmxUmOoHTSMCuSy1kUZbFy8y0=";
    # Most patches are in submodules
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch2 {
      name = "fix-tests.patch";
      url = "https://github.com/SkyTemple/skytemple-files/commit/854e5514e6c63ba082618d14643e3a4b30a6c2b2.patch";
      hash = "sha256-oTV2EQQ2OPgu2pYB2fLd4jODfybnV29YNLxzDs2v6Cg=";
    })
  ];

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

  passthru.optional-dependencies = {
    spritecollab = [
      aiohttp
      gql
      graphql-core
      lru-dict
    ] ++ gql.optional-dependencies.aiohttp;
  };

  nativeCheckInputs = [
    pytestCheckHook
    parameterized
    xmldiff
  ] ++ passthru.optional-dependencies.spritecollab;
  pytestFlagsArray = [ "test/" ];
  disabledTestPaths = [
    "test/skytemple_files_test/common/spritecollab/sc_online_test.py"
    "test/skytemple_files_test/compression_container/atupx/atupx_test.py" # Particularly long test
  ];

  pythonImportsCheck = [ "skytemple_files" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-files";
    description = "Python library to edit the ROM of Pokémon Mystery Dungeon Explorers of Sky";
    mainProgram = "skytemple_export_maps";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 ];
    broken = stdenv.isDarwin; # pyobjc is missing
  };
}
