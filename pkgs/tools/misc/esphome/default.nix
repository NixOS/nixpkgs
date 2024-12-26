{
  lib,
  callPackage,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  platformio,
  esptool,
  git,
  inetutils,
  stdenv,
  nixosTests,
}:

let
  python = python3Packages.python.override {
    self = python;
    packageOverrides = self: super: {
      esphome-dashboard = self.callPackage ./dashboard.nix { };
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "esphome";
  version = "2024.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-VW9p3VNVJOw5vkjCU4fujG0ie4N2D2QLidBANPV512U=";
  };

  build-systems = with python.pkgs; [
    setuptools
    argcomplete
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    "esptool"
    "platformio"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==" "setuptools>=" \
      --replace-fail "wheel~=" "wheel>="

    # ensure component dependencies are available
    cat requirements_optional.txt >> requirements.txt
  '';

  # Remove esptool and platformio from requirements
  env.ESPHOME_USE_SUBPROCESS = "";

  # esphome has optional dependencies it does not declare, they are
  # loaded when certain config blocks are used.
  # They have validation functions like:
  # - validate_cryptography_installed for the wifi component
  dependencies = with python.pkgs; [
    aioesphomeapi
    argcomplete
    cairosvg
    click
    colorama
    cryptography
    esphome-dashboard
    freetype-py
    icmplib
    glyphsets
    kconfiglib
    packaging
    paho-mqtt
    pillow
    platformio
    protobuf
    puremagic
    pyparsing
    pyserial
    pyyaml
    requests
    ruamel-yaml
    tornado
    tzdata
    tzlocal
    voluptuous
  ];

  makeWrapperArgs = [
    # platformio is used in esphome/platformio_api.py
    # esptool is used in esphome/__main__.py
    # git is used in esphome/writer.py
    # inetutils is used in esphome/dashboard/status/ping.py
    "--prefix PATH : ${
      lib.makeBinPath [
        platformio
        esptool
        git
        inetutils
      ]
    }"
    "--prefix PYTHONPATH : ${python.pkgs.makePythonPath dependencies}" # will show better error messages
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc ]}"
    "--set ESPHOME_USE_SUBPROCESS ''"
    # https://github.com/NixOS/nixpkgs/issues/362193
    "--set PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION 'python'"
  ];

  # Needed for tests
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = with python3Packages; [
    hypothesis
    mock
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  postCheck = ''
    $out/bin/esphome --help > /dev/null
  '';

  postInstall =
    let
      argcomplete = lib.getExe' python3Packages.argcomplete "register-python-argcomplete";
    in
    ''
      installShellCompletion --cmd esphome \
        --bash <(${argcomplete} --shell bash esphome) \
        --zsh <(${argcomplete} --shell zsh esphome) \
        --fish <(${argcomplete} --shell fish esphome)
    '';

  passthru = {
    dashboard = python.pkgs.esphome-dashboard;
    updateScript = callPackage ./update.nix { };
    tests = { inherit (nixosTests) esphome; };
  };

  meta = with lib; {
    changelog = "https://github.com/esphome/esphome/releases/tag/${version}";
    description = "Make creating custom firmwares for ESP32/ESP8266 super easy";
    homepage = "https://esphome.io/";
    license = with licenses; [
      mit # The C++/runtime codebase of the ESPHome project (file extensions .c, .cpp, .h, .hpp, .tcc, .ino)
      gpl3Only # The python codebase and all other parts of this codebase
    ];
    maintainers = with maintainers; [
      globin
      hexa
    ];
    mainProgram = "esphome";
  };
}
