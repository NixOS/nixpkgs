{
  mkKdeDerivation,
  pkg-config,
  libksysguard,
  lm_sensors,
  libnl,
}:
mkKdeDerivation {
  pname = "ksystemstats";

  patches = [
    ./helper-path.patch
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    lm_sensors
    libnl
  ];

  extraCmakeFlags = [
    "-DSYSTEMSTATS_DBUS_INTERFACE=${libksysguard}/share/dbus-1/interfaces/org.kde.ksystemstats1.xml"
  ];
}
