{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cargo
, rustc
, pkg-config
, asciidoc
, ncurses
, glibc
, dbus
, cryptsetup
, util-linux
, lvm2
, systemd
, xfsprogs
, thin-provisioning-tools
, clevis
, jose
, jq
, curl
, tpm2-tools
, coreutils
, clevisSupport ? false
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "stratisd";
  version = "3.6.4";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "refs/tags/stratisd-v${version}";
    hash = "sha256-0zSMFjAzTtTmpSCqlIq5GXk3/AhlhtECFZXmo6xcjWA=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    substituteInPlace udev/61-stratisd.rules \
      --replace stratis-base32-decode "$out/lib/udev/stratis-base32-decode" \
      --replace stratis-str-cmp       "$out/lib/udev/stratis-str-cmp"

    substituteInPlace systemd/stratis-fstab-setup \
      --replace stratis-min           "$out/bin/stratis-min" \
      --replace systemd-ask-password  "${systemd}/bin/systemd-ask-password" \
      --replace sleep                 "${coreutils}/bin/sleep" \
      --replace udevadm               "${systemd}/bin/udevadm"
  '';

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
    pkg-config
    asciidoc
    ncurses # tput
  ];

  buildInputs = [
    glibc
    glibc.static
    dbus
    cryptsetup
    util-linux
    systemd
    lvm2
  ];

  outputs = [ "out" "initrd" ];

  env.EXECUTABLES_PATHS = lib.makeBinPath ([
    xfsprogs
    thin-provisioning-tools
  ] ++ lib.optionals clevisSupport [
    clevis
    jose
    jq
    cryptsetup
    curl
    tpm2-tools
    coreutils
  ]);

  makeFlags = [ "PREFIX=${placeholder "out"}" "INSTALL=install" ];
  buildFlags = [ "build-all" ];

  doCheck = true;
  checkTarget = "test";

  # remove files for supporting dracut
  postInstall = ''
    mkdir -p "$initrd/bin"
    cp "$out/lib/dracut/modules.d/90stratis/stratis-rootfs-setup" "$initrd/bin"
    mkdir -p "$initrd/lib/systemd/system"
    substitute "$out/lib/dracut/modules.d/90stratis/stratisd-min.service" \
      "$initrd/lib/systemd/system/stratisd-min.service" \
      --replace mkdir "${coreutils}/bin/mkdir"
    mkdir -p "$initrd/lib/udev/rules.d"
    cp udev/61-stratisd.rules "$initrd/lib/udev/rules.d"
    rm -r "$out/lib/dracut"
    rm -r "$out/lib/systemd/system-generators"
  '';

  passthru.tests = nixosTests.stratis // {
    inherit (nixosTests.installer-systemd-stage-1) stratisRoot;
  };

  meta = with lib; {
    description = "Easy to use local storage management for Linux";
    homepage = "https://stratis-storage.github.io";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
