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
, IOKit
, testers
, nix-update-script
, pname ? "pcsclite"
, polkitSupport ? false
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  version = "2.0.3";

  outputs = [ "out" "lib" "dev" "doc" "man" ];

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "rousseau";
    repo = "PCSC";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-VDQh2PYAMFwgWvZFD20H3JxgKSFrSUoDLv/6fKEoy5Y=";
  };

  configureFlags = [
    "--enable-confdir=/etc"
    # The OS should care on preparing the drivers into this location
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
    (lib.enableFeature stdenv.isLinux "libsystemd")
    (lib.enableFeature polkitSupport "polkit")
  ] ++ lib.optionals stdenv.isLinux [
    "--enable-ipcdir=/run/pcscd"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  makeFlags = [
    "POLICY_DIR=$(out)/share/polkit-1/actions"
  ];

  # disable building pcsc-wirecheck{,-gen} when cross compiling
  # see also: https://github.com/LudovicRousseau/PCSC/issues/25
  postPatch = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace src/Makefile.am \
      --replace "noinst_PROGRAMS = testpcsc pcsc-wirecheck pcsc-wirecheck-gen" \
                "noinst_PROGRAMS = testpcsc"
  '';

  postInstall = ''
    # pcsc-spy is a debugging utility and it drags python into the closure
    moveToOutput bin/pcsc-spy "$dev"
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
    ++ lib.optionals stdenv.isLinux [ systemdLibs ]
    ++ lib.optionals stdenv.isDarwin [ IOKit ]
    ++ lib.optionals polkitSupport [ dbus polkit ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "pcscd --version";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = "https://pcsclite.apdu.fr/";
    changelog = "https://salsa.debian.org/rousseau/PCSC/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.bsd3;
    mainProgram = "pcscd";
    maintainers = [ maintainers.anthonyroussel ];
    platforms = with platforms; unix;
  };
})
