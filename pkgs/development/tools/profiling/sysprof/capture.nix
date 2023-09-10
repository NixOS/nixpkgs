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
    "-Dagent=false"
    "-Dsysprofd=none"
    "-Dgtk=false"
    "-Dlibsysprof=false"
    "-Dlibunwind=false"
    "-Dhelp=false"
    "-Dtools=false"
    "-Dtests=false"
    "-Dexamples=false"
  ];

  meta = sysprof.meta // {
    description = "Static library for Sysprof capture data generation";
    license = lib.licenses.bsd2Patent;
    platforms = lib.platforms.all;
    pkgConfigModules = [ "sysprof-capture-4" ];
  };
}
