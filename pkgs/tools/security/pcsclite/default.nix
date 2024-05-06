{ stdenv
, lib
, fetchFromGitLab
, autoreconfHook
, autoconf-archive
, flex
, pkg-config
, perl
, python3
, dbus
, polkit
, systemdLibs
, dbusSupport ? stdenv.isLinux
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs
, udevSupport ? dbusSupport
, libusb1
, IOKit
, testers
, nix-update-script
, pname ? "pcsclite"
, polkitSupport ? false
}:

assert polkitSupport -> dbusSupport;
assert systemdSupport -> dbusSupport;

stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  version = "2.1.0";

  outputs = [ "out" "lib" "dev" "doc" "man" ];

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "rousseau";
    repo = "PCSC";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-aJKI6pWrZJFmiTxZ9wgCuxKRWRMFVRAkzlo+tSqV8B4=";
  };

  configureFlags = [
    "--enable-confdir=/etc"
    # The OS should care on preparing the drivers into this location
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
    (lib.enableFeature systemdSupport "libsystemd")
    (lib.enableFeature polkitSupport "polkit")
    "--enable-ipcdir=/run/pcscd"
  ] ++ lib.optionals systemdSupport [
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ] ++ lib.optionals (!udevSupport) [
    "--disable-libudev"
  ];

  makeFlags = [
    "POLICY_DIR=$(out)/share/polkit-1/actions"
  ];

  # disable building pcsc-wirecheck{,-gen} when cross compiling
  # see also: https://github.com/LudovicRousseau/PCSC/issues/25
  postPatch = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace src/Makefile.am \
      --replace-fail "noinst_PROGRAMS = testpcsc pcsc-wirecheck pcsc-wirecheck-gen" \
                     "noinst_PROGRAMS = testpcsc"
  '';

  postInstall = ''
    # pcsc-spy is a debugging utility and it drags python into the closure
    moveToOutput bin/pcsc-spy "$dev"

    # libpcsclite loads its delegate (libpcsclite_real) dynamically.
    # To avoid downstream wrapping/patching, we add libpcsclite_real to the lib
    # Relevant code: https://salsa.debian.org/rousseau/PCSC/-/blob/773be65d160da07de2fc34616af475e06dbaa343/src/libredirect.c#L128
    patchelf $lib/lib/libpcsclite.so.1 \
      --add-needed libpcsclite_real.so.1
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    flex
    pkg-config
    perl
  ];

  buildInputs = [ python3 ]
    ++ lib.optionals systemdSupport [ systemdLibs ]
    ++ lib.optionals stdenv.isDarwin [ IOKit ]
    ++ lib.optionals dbusSupport [ dbus ]
    ++ lib.optionals polkitSupport [ polkit ]
    ++ lib.optionals (!udevSupport) [ libusb1 ];

  passthru = {
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "pcscd --version";
      };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = "https://pcsclite.apdu.fr/";
    changelog = "https://salsa.debian.org/rousseau/PCSC/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.bsd3;
    mainProgram = "pcscd";
    maintainers = [ lib.maintainers.anthonyroussel ];
    pkgConfigModules = [ "libpcsclite" ];
    platforms = lib.platforms.unix;
  };
})
