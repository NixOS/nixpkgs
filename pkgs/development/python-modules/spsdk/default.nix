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
  pyocd,
  pyserial,
  requests,
  ruamel-yaml,
  sly,
  typing-extensions,

  # tests
  ipykernel,
  pytest-notebook,
  pytestCheckHook,
  voluptuous,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "spsdk";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nxp-mcuxpresso";
    repo = "spsdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-WRR4YyA4HaYoyOZSt/RYivhH2E/20DKLXExWg2yOL48=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=72.1,<74" "setuptools"

    substituteInPlace setup.py \
      --replace-fail "setuptools>=72.1,<74" "setuptools"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "cryptography"
    "requests"
    "packaging"
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
    pyocd
    pyserial
    requests
    ruamel-yaml
    sly
    typing-extensions
  ];

  pythonImportsCheck = [ "spsdk" ];

  preInstallCheck = ''
    export HOME="$(mktemp -d)"
  '';

  nativeCheckInputs = [
    ipykernel
    pytest-notebook
    pytestCheckHook
    voluptuous
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  disabledTests = [
    # Missing rotk private key
    "test_general_notebooks"
  ];

  meta = {
    changelog = "https://github.com/nxp-mcuxpresso/spsdk/blob/v${version}/docs/release_notes.rst";
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
