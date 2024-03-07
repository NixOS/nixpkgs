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
  version = "2.0.1";

  outputs = [ "bin" "out" "dev" "doc" "man" ];

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "rousseau";
    repo = "PCSC";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-7NGlU4byGxtGBticewg8K4FUiDSQZAiB7Q/y+LaqKPo=";
  };

  configureFlags = [
    "--enable-confdir=/etc"
    # The OS should care on preparing the drivers into this location
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
    (lib.enableFeature stdenv.isLinux "libsystemd")
    (lib.enableFeature polkitSupport "polkit")
  ] ++ lib.optionals stdenv.isLinux [
    "--enable-ipcdir=/run/pcscd"
    "--with-systemdsystemunitdir=${placeholder "bin"}/lib/systemd/system"
  ];

  makeFlags = [
    "POLICY_DIR=$(out)/share/polkit-1/actions"
  ];

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
