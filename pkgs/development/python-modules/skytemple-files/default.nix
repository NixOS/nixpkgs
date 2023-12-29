{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, appdirs
, dungeon-eos
, explorerscript
, ndspy
, pillow
, setuptools
, skytemple-rust
, tilequant
, pyyaml
, pmdsky-debug-py
, typing-extensions
, pythonOlder
, # optional dependancies for SpriteCollab
  aiohttp
, lru-dict
, graphql-core
, gql
, armips
  # tests
, pytestCheckHook
, parameterized
, xmldiff
}:

buildPythonPackage rec {
  pname = "skytemple-files";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    hash = "sha256-PVHI3SuXXH+XpSaBhtSUT5I6wYK3WmwW67nJmPLKdg4=";
    fetchSubmodules = true;
  };

  patches = [
    # Necessary for skytemple-files to work with Pillow 10.1.0.
    # https://github.com/SkyTemple/skytemple-files/issues/449
    (fetchpatch {
      url = "https://github.com/SkyTemple/skytemple-files/commit/5dc6477d5411b43b80ba79cdaf3521d75d924233.patch";
      hash = "sha256-0511IRjOcQikhnbu3FkXn92mLAkO+kV9J94Z3f7EBcU=";
      includes = ["skytemple_files/graphics/kao/_model.py"];
    })
    (fetchpatch {
      url = "https://github.com/SkyTemple/skytemple-files/commit/9548f7cf3b1d834555b41497cfc0bddab10fd3f6.patch";
      hash = "sha256-a3GeR5IxXRIKY7I6rhKbOcQnoKxtH7Xf3Wx/BRFQHSc=";
    })
  ];

  postPatch = ''
    substituteInPlace skytemple_files/patch/arm_patcher.py skytemple_files/data/data_cd/armips_importer.py \
      --replace "exec_name = os.getenv(\"SKYTEMPLE_ARMIPS_EXEC\", f\"{prefix}armips\")" "exec_name = \"${armips}/bin/armips\""
  '';

  buildInputs = [ armips ];

  propagatedBuildInputs = [
    appdirs
    dungeon-eos
    explorerscript
    ndspy
    pillow
    setuptools
    skytemple-rust
    tilequant
    pyyaml
    pmdsky-debug-py
  ] ++ lib.optionals (pythonOlder "3.9") [
    typing-extensions
  ];

  passthru.optional-dependencies = {
    spritecollab = [
      aiohttp
      gql
      graphql-core
      lru-dict
    ] ++ gql.optional-dependencies.aiohttp;
  };

  checkInputs = [ pytestCheckHook parameterized xmldiff ] ++ passthru.optional-dependencies.spritecollab;
  pytestFlagsArray = [ "test/" ];
  disabledTestPaths = [
    "test/skytemple_files_test/common/spritecollab/sc_online_test.py"
    "test/skytemple_files_test/compression_container/atupx/atupx_test.py" # Particularly long test
  ];

  pythonImportsCheck = [ "skytemple_files" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-files";
    description = "Python library to edit the ROM of Pokémon Mystery Dungeon Explorers of Sky";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix marius851000 ];
    broken = stdenv.isDarwin; # pyobjc is missing
  };
}
