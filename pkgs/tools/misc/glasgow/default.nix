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
  version = "unstable-2023-04-15";
  # python -m setuptools_scm
  realVersion = "0.1.dev2+g${lib.substring 0 7 src.rev}";

  patches = [ ./0001-Relax-Amaranth-git-dependency.patch ];

  src = fetchFromGitHub {
    owner = "GlasgowEmbedded";
    repo = "glasgow";
    rev = "406e06fae5c85f6f773c9839747513874bc3ec77";
    sha256 = "sha256-s4fWpKJj6n2+CIAsD2bjr5K8RhJz1H1sFnjiartNGf0=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools-scm
    sdcc
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    amaranth
    bitarray
    crc
    fx2
    libusb1
    pyvcd
    setuptools
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
