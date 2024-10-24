{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  asn1crypto,
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
  packaging,
  platformdirs,
  prettytable,
  pyocd,
  pyserial,
  requests,
  ruamel-yaml,
  setuptools-scm,
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
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nxp-mcuxpresso";
    repo = "spsdk";
    rev = "refs/tags/${version}";
    hash = "sha256-qFgG9jdF667EtMqXGGk/oxTEi+6J2s/3gKokP+JaFVw=";
  };

  build-system = [ setuptools-scm ];

  pythonRelaxDeps = [
    "cryptography"
    "requests"
    "packaging"
    "typing-extensions"
  ];

  # Remove unneeded unfree package. pyocd-pemicro is only used when
  # generating a pyinstaller package, which we don't do.
  pythonRemoveDeps = [ "pyocd-pemicro" ];

  dependencies = [
    asn1crypto
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
    packaging
    platformdirs
    prettytable
    pyocd
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
