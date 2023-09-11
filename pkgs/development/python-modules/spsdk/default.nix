{ lib
, buildPythonPackage
, fetchFromGitHub
, dos2unix
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
, ruamel-yaml
, sly
, typing-extensions
, pytestCheckHook
, voluptuous
}:

buildPythonPackage rec {
  pname = "spsdk";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "nxp-mcuxpresso";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-B3qedAXSG3A8rcWu1O2GnZ1ZqHN+7fQK43qXzGnDEY0=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
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
    jinja2
    libusbsio
    oscrypto
    pycryptodome
    pylink-square
    pyocd
    pypemicro
    pyserial
    ruamel-yaml
    sly
    typing-extensions
  ];

  nativeCheckInputs = [
    importlib-metadata
    pyftdi
    pytestCheckHook
    voluptuous
  ];

  pythonImportsCheck = [ "spsdk" ];

  meta = with lib; {
    changelog = "https://github.com/nxp-mcuxpresso/spsdk/blob/${src.rev}/docs/release_notes.rst";
    description = "NXP Secure Provisioning SDK";
    homepage = "https://github.com/nxp-mcuxpresso/spsdk";
    license = licenses.bsd3;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
