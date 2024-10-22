{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, flex
, pkg-config
, perl
, python3
, dbus
, polkit
, systemdLibs
, udev
, dbusSupport ? stdenv.hostPlatform.isLinux
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs
, udevSupport ? dbusSupport
, libusb1
, Foundation
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
  version = "2.2.3";

  outputs = [ "out" "lib" "dev" "doc" "man" ];

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "rousseau";
    repo = "PCSC";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-hKyxXqZaqg8KGFoBWhRHV1/50uoxqiG0RsYtgw2BuQ4=";
  };

  # fix build with macOS 11 SDK
  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/rousseau/PCSC/-/commit/f41fdaaf7c82bc270af6d7439c6da037bf149be8.patch";
      revert = true;
      hash = "sha256-8A76JfYqcILi52X9l/uIpJXeRJDf2dkrNEToOsxGZXk=";
    })
  ];

  mesonFlags = [
    (lib.mesonOption "sysconfdir" "/etc")
    # The OS should care on preparing the drivers into this location
    (lib.mesonOption "usbdropdir" "/var/lib/pcsc/drivers")
    (lib.mesonBool "libsystemd" systemdSupport)
    (lib.mesonBool "polkit" polkitSupport)
    (lib.mesonOption "ipcdir" "/run/pcscd")
  ] ++ lib.optionals systemdSupport [
    (lib.mesonOption "systemdunit" "system")
  ] ++ lib.optionals (!udevSupport) [
    (lib.mesonBool "libudev" false)
  ];

  # disable building pcsc-wirecheck{,-gen} when cross compiling
  # see also: https://github.com/LudovicRousseau/PCSC/issues/25
  postPatch = ''
    substituteInPlace src/libredirect.c src/spy/libpcscspy.c \
      --replace-fail "libpcsclite_real.so.1" "$lib/lib/libpcsclite_real.so.1"
  '' + lib.optionalString systemdSupport ''
    substituteInPlace meson.build \
      --replace-fail \
        "systemdsystemunitdir = systemd.get_variable(pkgconfig : 'systemd' + unit + 'unitdir')" \
        "systemdsystemunitdir = '${placeholder "out"}/lib/systemd/system'"
  '' + lib.optionalString polkitSupport ''
    substituteInPlace meson.build \
      --replace-fail \
        "install_dir : polkit_dep.get_variable('policydir')" \
        "install_dir : '${placeholder "out"}/share/polkit-1/actions'"
  '';

  postInstall = ''
    # pcsc-spy is a debugging utility and it drags python into the closure
    moveToOutput bin/pcsc-spy "$dev"
  '';

  nativeBuildInputs = [
    meson
    ninja
    flex
    pkg-config
    perl
  ];

  buildInputs = [ python3 ]
    ++ lib.optionals systemdSupport [ systemdLibs ]
    ++ lib.optionals (!systemdSupport && udevSupport) [ udev ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Foundation IOKit ]
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
