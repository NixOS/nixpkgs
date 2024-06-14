{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  asn1crypto,
  astunparse,
  bincopy,
  bitstring,
  click,
  click-command-tree,
  click-option-group,
  colorama,
  crcmod,
  cryptography,
  deepmerge,
  fastjsonschema,
  hexdump,
  libusbsio,
  oscrypto,
  platformdirs,
  prettytable,
  pylink-square,
  pyocd,
  pyocd-pemicro,
  pypemicro,
  pyserial,
  requests,
  ruamel-yaml,
  setuptools,
  sly,
  spsdk,
  testers,
  typing-extensions,
  ipykernel,
  pytest-notebook,
  pytestCheckHook,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "spsdk";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nxp-mcuxpresso";
    repo = "spsdk";
    rev = "refs/tags/${version}";
    hash = "sha256-cWz2zML/gb9l2C5VEBti+nX3ZLyGbLFyLZGjk5GfTJw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonRelaxDeps = [
    "click"
    "cryptography"
    "platformdirs"
    "typing-extensions"
  ];

  propagatedBuildInputs = [
    asn1crypto
    astunparse
    bincopy
    bitstring
    click
    click-command-tree
    click-option-group
    colorama
    crcmod
    cryptography
    deepmerge
    fastjsonschema
    hexdump
    libusbsio
    oscrypto
    platformdirs
    prettytable
    pylink-square
    pyocd
    pyocd-pemicro
    pypemicro
    pyserial
    requests
    ruamel-yaml
    sly
    typing-extensions
  ];

  nativeCheckInputs = [
    ipykernel
    pytest-notebook
    pytestCheckHook
    voluptuous
  ];

  disabledTests = [
    "test_nxpcrypto_create_signature_algorithm"
    "test_nxpimage_sb31_kaypair_not_matching"
  ];

  pythonImportsCheck = [ "spsdk" ];

  passthru.tests.version = testers.testVersion { package = spsdk; };

  meta = with lib; {
    changelog = "https://github.com/nxp-mcuxpresso/spsdk/blob/${src.rev}/docs/release_notes.rst";
    description = "NXP Secure Provisioning SDK";
    homepage = "https://github.com/nxp-mcuxpresso/spsdk";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      frogamic
      sbruder
    ];
    mainProgram = "spsdk";
  };
}
