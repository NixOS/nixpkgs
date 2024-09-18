{ stdenv
, lib
, fetchbzr
, testers
, autoreconfHook
, bash
, dbus
, dbus-glib
, glib
, intltool
, pkg-config
, python3
, xvfb-run
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dbus-test-runner";
  version = "unstable-2019-10-02";

  src = fetchbzr {
    url = "lp:dbus-test-runner";
    rev = "109";
    sha256 = "sha256-4yH19X98SVqpviCBIWzIX6FYHWxCbREpuKCNjQuTFDk=";
  };

  postPatch = ''
    patchShebangs tests/test-wait-outputer

    # Tests `cat` together build shell scripts
    # true is a PATHable call, bash a shebang
    substituteInPlace tests/Makefile.am \
      --replace '/bin/true' 'true' \
      --replace '/bin/bash' '${lib.getExe bash}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    glib # for autoconf macro, gtester, gdbus
    intltool
    pkg-config
  ];

  buildInputs = [
    dbus-glib
    glib
  ];

  nativeCheckInputs = [
    bash
    dbus
    (python3.withPackages (ps: with ps; [
      python-dbusmock
    ]))
    xvfb-run
  ];

  enableParallelBuilding = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkFlags = [
    "XVFB_RUN=${lib.getExe xvfb-run}"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Small little utility to run a couple of executables under a new DBus session for testing";
    mainProgram = "dbus-test-runner";
    homepage = "https://launchpad.net/dbus-test-runner";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = teams.lomiri.members;
    pkgConfigModules = [
      "dbustest-1"
    ];
  };
})
