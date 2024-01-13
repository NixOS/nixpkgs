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
  version = "unstable-2023-09-20";
  # python -m setuptools_scm
  realVersion = "0.1.dev1798+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "GlasgowEmbedded";
    repo = "glasgow";
    rev = "e9a9801d5be3dcba0ee188dd8a6e9115e337795d";
    sha256 = "sha256-ztB3I/jrDSm1gKB1e5igivUVloq+YYhkshDlWg75NMA=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools-scm
    sdcc
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    amaranth
    appdirs
    bitarray
    crc
    fx2
    libusb1
    packaging
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

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp $src/config/99-glasgow.rules $out/etc/udev/rules.d
  '';

  checkPhase = ''
    # tests attempt to cache bitstreams
    # for linux:
    export XDG_CACHE_HOME=$TMPDIR
    # for darwin:
    export HOME=$TMPDIR
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
    mainProgram = "glasgow";
  };
}
