{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "refs/tags/stratisd-v${version}";
    hash = "sha256-Wu3SkuHyMCBape+pMymQntXRtdMIlF5wz75kKxaZlms=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "loopdev-0.4.0" = "sha256-YS0hqxphxbbImT/mn/XBzkgabK2kbIym5VqG3XDVAx8=";
    };
  };

  patches = [
    # Can be removed with the next release after v. 3.6.3
    (fetchpatch {
      name = "remove-unused-imports.patch";
      url = "https://github.com/stratis-storage/stratisd/commit/78440de6e6ed8eab5ddd25dbdfb7804d0698f2a2.patch";
      hash = "sha256-RW2nyAWaoIbqrgbhCApQsMXkJWtWoOWL3VO7fIImJgY=";
    })

    # Can be removed with the next release after v. 3.6.3
    (fetchpatch {
      name = "flag-import-not-used-in-build-as-test-only.patch";
      url = "https://github.com/stratis-storage/stratisd/commit/0d1c67f71338d0ee6c1e6aa06f7fd6264ce9a4c5.patch";
      hash = "sha256-6Nb8izUqYUirjy0dTFhITxoM/AKoChoc0w6Qm9K6+7I=";
    })
  ];

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
    cp "dracut/90stratis/stratis-rootfs-setup" "$initrd/bin"
    mkdir -p "$initrd/lib/systemd/system"
    substitute "dracut/90stratis/stratisd-min.service" "$initrd/lib/systemd/system/stratisd-min.service" \
      --replace /usr "$out" \
      --replace mkdir "${coreutils}/bin/mkdir"
    mkdir -p "$initrd/lib/udev/rules.d"
    cp udev/61-stratisd.rules "$initrd/lib/udev/rules.d"
    rm -r "$out/lib/dracut"
    rm -r "$out/lib/systemd/system-generators"
  '';

  passthru.tests = nixosTests.stratis;

  meta = with lib; {
    description = "Easy to use local storage management for Linux";
    homepage = "https://stratis-storage.github.io";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
