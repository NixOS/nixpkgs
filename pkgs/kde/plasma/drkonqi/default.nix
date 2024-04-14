{
  mkKdeDerivation,
  pkg-config,
  systemd,
  gdb,
  python3,
  substituteAll,
  coreutils,
}: let
  gdb' = gdb.override {
    hostCpuOnly = true;
    python3 = python3.withPackages (ps: [
      ps.psutil
      ps.pygdbmi
      ps.sentry-sdk
    ]);
  };
in
  mkKdeDerivation {
    pname = "drkonqi";

    patches = [
      (substituteAll {
        src = ./gdb-path.patch;
        gdb = "${gdb'}/bin/gdb";
      })
    ];

    postPatch = ''
      substituteInPlace src/coredump/processor/drkonqi-coredump-pickup.service.cmake \
        --replace /usr/bin/sleep ${coreutils}/bin/sleep
    '';

    extraNativeBuildInputs = [pkg-config];
    extraBuildInputs = [systemd];

    extraCmakeFlags = [
      "-DWITH_GDB12=1"
      "-DWITH_PYTHON_VENDORING=0"
    ];
  }
