{ lib
, callPackage
, python3Packages
, fetchFromGitHub
, installShellFiles
, platformio
, esptool
, git
, inetutils
, stdenv
}:

let
  python = python3Packages.python.override {
    packageOverrides = self: super: {
      esphome-dashboard = self.callPackage ./dashboard.nix { };
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "esphome";
  version = "2024.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-lWDQp3I8AJT5iTT8wMj/ZL6ykw2NNeLXdq1obnMP7Ao=";
  };

  nativeBuildInputs = with python.pkgs; [
    setuptools
    argcomplete
    installShellFiles
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = true;

  postPatch = ''
    # drop coverage testing
    sed -i '/--cov/d' pytest.ini
  '';

  # Remove esptool and platformio from requirements
  ESPHOME_USE_SUBPROCESS = "";

  # esphome has optional dependencies it does not declare, they are
  # loaded when certain config blocks are used, like `font`, `image`
  # or `animation`.
  # They have validation functions like:
  # - validate_cryptography_installed
  # - validate_pillow_installed
  propagatedBuildInputs = with python.pkgs; [
    aioesphomeapi
    argcomplete
    click
    colorama
    cryptography
    esphome-dashboard
    icmplib
    kconfiglib
    packaging
    paho-mqtt
    pillow
    platformio
    protobuf
    pyparsing
    pyserial
    python-magic
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
    "--prefix PATH : ${lib.makeBinPath [ platformio esptool git inetutils ]}"
    "--prefix PYTHONPATH : ${python.pkgs.makePythonPath propagatedBuildInputs}" # will show better error messages
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
    "--set ESPHOME_USE_SUBPROCESS ''"
  ];

  # Needed for tests
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = with python3Packages; [
    hypothesis
    mock
    pytest-asyncio
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
  };

  meta = with lib; {
    changelog = "https://github.com/esphome/esphome/releases/tag/${version}";
    description = "Make creating custom firmwares for ESP32/ESP8266 super easy";
    homepage = "https://esphome.io/";
    license = with licenses; [
      mit # The C++/runtime codebase of the ESPHome project (file extensions .c, .cpp, .h, .hpp, .tcc, .ino)
      gpl3Only # The python codebase and all other parts of this codebase
    ];
    maintainers = with maintainers; [ globin hexa ];
    mainProgram = "esphome";
  };
}
