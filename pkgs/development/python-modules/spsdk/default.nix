{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, dos2unix
, pythonRelaxDepsHook
, asn1crypto
, astunparse
, bincopy
, bitstring
, click
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
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "NXPmicro";
    repo = pname;
    rev = version;
    sha256 = "sha256-JMhd2XdbjEN6SUzFgcBHd/dStiuYeXXis6pfijSfUso=";
  };

  patches = [
    # https://github.com/NXPmicro/spsdk/pull/43
    (fetchpatch {
      name = "cryptography-37-compat.patch";
      url = "https://github.com/NXPmicro/spsdk/commit/a85b854de1093de593d27fa64de442224ab2e0fd.patch";
      sha256 = "sha256-4pXV/8RaNuGl7KNdoGD/8YnPQ2ZmUQOjXWA/Yy0Kxu8=";
    })
    # https://github.com/NXPmicro/spsdk/pull/41
    (fetchpatch {
      name = "blhost-click-8-1-compat.patch";
      url = "https://github.com/NXPmicro/spsdk/commit/5112b1b69aa681d265035475e73d28ea0c8cb6ab.patch";
      sha256 = "sha256-Okz6Er6OVuAA5IlB5IabSa/gUSLa+E2Ltd+J3uoIg6o=";
    })
  ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [
    "cmsis-pack-manager"
    "cryptography"
    "deepmerge"
    "jinja2"
    "pylink-square"
    "pyocd"
  ];
  pythonRemoveDeps = [ "pyocd-pemicro" ];

  propagatedBuildInputs = [
    asn1crypto
    astunparse
    bincopy
    bitstring
    click
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

  checkInputs = [
    pytestCheckHook
    voluptuous
  ];

  disabledTests = [
    # tests also fail on debian, so presumable they are broken
    "test_elftosb_mbi_signed"
    "test_elftosb_sb31"
  ];

  pythonImportsCheck = [ "spsdk" ];

  meta = with lib; {
    description = "NXP Secure Provisioning SDK";
    homepage = "https://github.com/NXPmicro/spsdk";
    license = licenses.bsd3;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
