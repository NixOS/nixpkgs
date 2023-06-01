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
, typing-extensions
, pytestCheckHook
, voluptuous
}:

buildPythonPackage rec {
  pname = "spsdk";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "NXPmicro";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-KJUtAWENS3+VAs3Iai1aKYzMYtfetMeI0MHeQ6NraNY=";
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
