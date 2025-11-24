{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
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
  filelock,
  hexdump,
  libusbsio,
  libuuu,
  oscrypto,
  packaging,
  platformdirs,
  prettytable,
  pyasn1,
  pyocd,
  pyserial,
  requests,
  ruamel-yaml,
  sly,
  spsdk-mcu-link,
  spsdk-pyocd,
  typing-extensions,
  x690,

  # tests
  cookiecutter,
  ipykernel,
  pytest-notebook,
  pytestCheckHook,
  voluptuous,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "spsdk";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nxp-mcuxpresso";
    repo = "spsdk";
    tag = "v${version}";
    hash = "sha256-unJpJjoS0C9TKsvk9/fQO8jiIOGbgfJopeXR5FcIq/g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=72.1,<74" "setuptools" \
      --replace-fail "setuptools_scm<8.2" "setuptools_scm"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "cryptography"
    "filelock"
    "importlib-metadata"
    "packaging"
    "prettytable"
    "requests"
    "setuptools_scm"
    "typing-extensions"
  ];

  pythonRemoveDeps = [
    # Remove unneeded unfree package. pyocd-pemicro is only used when
    # generating a pyinstaller package, which we don't do.
    "pyocd-pemicro"
  ];

  dependencies = [
    asn1crypto
    bincopy
    bitstring
    click
    click-command-tree
    click-option-group
    colorama
    cookiecutter
    crcmod
    cryptography
    deepmerge
    fastjsonschema
    filelock
    hexdump
    libusbsio
    libuuu
    oscrypto
    packaging
    platformdirs
    prettytable
    pyasn1
    pyocd
    pyserial
    requests
    ruamel-yaml
    sly
    spsdk-mcu-link
    spsdk-pyocd
    typing-extensions
    x690
  ];

  pythonImportsCheck = [ "spsdk" ];

  nativeCheckInputs = [
    cookiecutter
    ipykernel
    pytest-notebook
    pytestCheckHook
    voluptuous
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";

  disabledTests = [
    # Missing rotk private key
    "test_general_notebooks"

    # Attempts to access /run
    "test_nxpimage_famode_export_cli"
  ];

  meta = {
    changelog = "https://github.com/nxp-mcuxpresso/spsdk/blob/${src.tag}/docs/release_notes.rst";
    description = "NXP Secure Provisioning SDK";
    homepage = "https://github.com/nxp-mcuxpresso/spsdk";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      frogamic
      sbruder
    ];
    mainProgram = "spsdk";
  };
}
