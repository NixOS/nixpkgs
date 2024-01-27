{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonRelaxDepsHook
, asn1crypto
, astunparse
, bincopy
, bitstring
, click
, click-command-tree
, click-option-group
, cmsis-pack-manager
, commentjson
, crcmod
, cryptography
, deepmerge
, fastjsonschema
, hexdump
, importlib-metadata
, jinja2
, libusbsio
, oscrypto
, pycryptodome
, pyftdi
, pylink-square
, pyocd
, pypemicro
, pyserial
, requests
, ruamel-yaml
, setuptools
, sly
, spsdk
, testers
, typing-extensions
, pytestCheckHook
, voluptuous
}:

buildPythonPackage rec {
  pname = "spsdk";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nxp-mcuxpresso";
    repo = pname;
    rev = version;
    hash = "sha256-C6cz5jhIHI4WkCYT0rURFa4kBAu6cMcKpQHiHACIiu8=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRelaxDeps = [
    "bincopy"
    "bitstring"
    "cmsis-pack-manager"
    "deepmerge"
    "jinja2"
    "pycryptodome"
    "pylink-square"
    "pyocd"
    "typing-extensions"
    "click"
    "ruamel.yaml"
  ];

  pythonRemoveDeps = [
    "pyocd-pemicro"
  ];

  propagatedBuildInputs = [
    asn1crypto
    astunparse
    bincopy
    bitstring
    click
    click-command-tree
    click-option-group
    cmsis-pack-manager
    commentjson
    crcmod
    cryptography
    deepmerge
    fastjsonschema
    hexdump
    importlib-metadata
    jinja2
    libusbsio
    oscrypto
    pycryptodome
    pylink-square
    pyocd
    pypemicro
    pyserial
    requests
    ruamel-yaml
    sly
    typing-extensions
  ];

  nativeCheckInputs = [
    pyftdi
    pytestCheckHook
    voluptuous
  ];

  pythonImportsCheck = [ "spsdk" ];

  passthru.tests.version = testers.testVersion { package = spsdk; };

  meta = with lib; {
    changelog = "https://github.com/nxp-mcuxpresso/spsdk/blob/${src.rev}/docs/release_notes.rst";
    description = "NXP Secure Provisioning SDK";
    homepage = "https://github.com/nxp-mcuxpresso/spsdk";
    license = licenses.bsd3;
    maintainers = with maintainers; [ frogamic sbruder ];
    mainProgram = "spsdk";
  };
}
