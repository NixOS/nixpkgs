{
  mkKdeDerivation,
  pkg-config,
  systemd,
  gdb,
  python3,
  substituteAll,
}:
let
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

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ systemd ];

  extraCmakeFlags = [
    "-DWITH_GDB12=1"
    "-DWITH_PYTHON_VENDORING=0"
  ];
}
