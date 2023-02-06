{ lib
, python3
, fetchFromGitHub
, sdcc
, yosys
, icestorm
, nextpnr
}:

python3.pkgs.buildPythonApplication rec {
  pname = "glasgow";
  version = "unstable-2021-12-12";
  # python software/setup.py --version
  realVersion = "0.1.dev1679+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "GlasgowEmbedded";
    repo = "glasgow";
    rev = "e640a778c446b7e9812727e73c560d12aeb41d7c";
    sha256 = "EsQ9ZjalKDQ54JOonra4yPDI56cF5n86y/Rd798cZsU=";
  };

  nativeBuildInputs = [ python3.pkgs.setuptools-scm sdcc ];

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    amaranth
    fx2
    libusb1
    aiohttp
    pyvcd
    bitarray
    crcmod
  ];

  nativeCheckInputs = [ yosys icestorm nextpnr ];

  enableParallelBuilding = true;

  preBuild = ''
    make -C firmware LIBFX2=${python3.pkgs.fx2}/share/libfx2
    cp firmware/glasgow.ihex software/glasgow
    cd software
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  # installCheck tries to build_ext again
  doInstallCheck = false;

  checkPhase = ''
    ${python3.interpreter} -W ignore::DeprecationWarning test.py
  '';

  makeWrapperArgs = [
    "--set" "YOSYS" "${yosys}/bin/yosys"
    "--set" "ICEPACK" "${icestorm}/bin/icepack"
    "--set" "NEXTPNR_ICE40" "${nextpnr}/bin/nextpnr-ice40"
  ];

  meta = with lib; {
    description = "Software for Glasgow, a digital interface multitool";
    homepage = "https://github.com/GlasgowEmbedded/Glasgow";
    license = licenses.bsd0;
    maintainers = with maintainers; [ emily thoughtpolice ];
  };
}
