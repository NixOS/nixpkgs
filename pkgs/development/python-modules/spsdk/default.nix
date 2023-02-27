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
, jinja2
, libusbsio
, oscrypto
, pycryptodome
, pylink-square
, pyocd
, pypemicro
, pyserial
, ruamel-yaml
, sly
, pytestCheckHook
, voluptuous
}:

buildPythonPackage rec {
  pname = "spsdk";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "NXPmicro";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-UBiylZB6/0n1FQMMg0coXkYh9S6gLz2LaoKk2HoWu7c=";
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
    "pylink-square"
    "pyocd"
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
  ];

  nativeCheckInputs = [
    pytestCheckHook
    voluptuous
  ];

  pythonImportsCheck = [ "spsdk" ];

  meta = with lib; {
    description = "NXP Secure Provisioning SDK";
    homepage = "https://github.com/NXPmicro/spsdk";
    license = licenses.bsd3;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
