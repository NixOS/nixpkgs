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
  version = "unstable-2024-06-28";
  realVersion = "0.1.dev2085+g${lib.substring 0 7 src.rev}";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GlasgowEmbedded";
    repo = "glasgow";
    rev = "a599e3caa64c2e445358894fd050e16917f2ee42";
    sha256 = "sha256-5qg0/j1MgwHMOjySBY5cKuQqlqltV5cXcR/Ap6J9vys=";
  };

  nativeBuildInputs = [
    python3.pkgs.unittestCheckHook
    python3.pkgs.pdm-backend
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
    platformdirs
    pyvcd
    setuptools
  ];

  nativeCheckInputs = [ yosys icestorm nextpnr ];

  enableParallelBuilding = true;

  preBuild = ''
    make -C firmware LIBFX2=${python3.pkgs.fx2}/share/libfx2
    cp firmware/glasgow.ihex software/glasgow
    cd software
    export PDM_BUILD_SCM_VERSION="${realVersion}"
  '';

  # installCheck tries to build_ext again
  doInstallCheck = false;

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp $src/config/70-cypress.rules $out/etc/udev/rules.d
    cp $src/config/70-glasgow.rules $out/etc/udev/rules.d
  '';

  preCheck = ''
    # tests attempt to cache bitstreams
    # for linux:
    export XDG_CACHE_HOME=$TMPDIR
    # for darwin:
    export HOME=$TMPDIR
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
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "glasgow";
  };
}
