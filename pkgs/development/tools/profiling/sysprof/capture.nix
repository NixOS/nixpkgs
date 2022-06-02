{ lib, stdenv
, meson
, ninja
, sysprof
}:

stdenv.mkDerivation rec {
  pname = "libsysprof-capture";

  inherit (sysprof) src version;

  nativeBuildInputs = [
    meson
    ninja
  ];

  mesonFlags = [
    "-Dwith_sysprofd=none"
    "-Dlibsysprof=false"
    "-Dlibunwind=false"
    "-Dhelp=false"
    "-Denable_tools=false"
    "-Denable_tests=false"
    "-Denable_examples=false"
  ];

  meta = sysprof.meta // {
    description = "Static library for Sysprof capture data generation";
    license = lib.licenses.bsd2Patent;
    platforms = lib.platforms.all;
  };
}
