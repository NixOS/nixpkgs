{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, asciidoc
, dbus
, cryptsetup
, util-linux
, udev
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
}:

stdenv.mkDerivation rec {
  pname = "stratisd";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dNbbKGRLSYVnPdKfxlLIwXNEf7P6EvGbOp8sfpaw38g=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-tJT0GKLpZtiQ/AZACkNeC3zgso54k/L03dFI0m1Jbls=";
  };

  patches = [
    # Allow overriding BINARIES_PATHS with environment variable at compile time
    ./paths.patch
  ];

  postPatch = ''
    substituteInPlace udev/61-stratisd.rules \
      --replace stratis-base32-decode "$out/lib/udev/stratis-base32-decode" \
      --replace stratis-str-cmp       "$out/lib/udev/stratis-str-cmp"

    substituteInPlace systemd/stratis-fstab-setup \
      --replace stratis-min           "$out/bin/stratis-min" \
      --replace systemd-ask-password  "${systemd}/bin/systemd-ask-password" \
      --replace sleep                 "${coreutils}/bin/sleep" \
      --replace udevadm               "${udev}/bin/udevadm"
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    bindgenHook
    rust.cargo
    rust.rustc
    pkg-config
    asciidoc
  ];

  buildInputs = [
    dbus
    cryptsetup
    util-linux
    udev
  ];

  BINARIES_PATHS = lib.makeBinPath ([
    xfsprogs
    thin-provisioning-tools
    udev
  ] ++ lib.optionals clevisSupport [
    clevis
    jose
    jq
    cryptsetup
    curl
    tpm2-tools
    coreutils
  ]);

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  buildFlags = [ "release" "release-min" "docs/stratisd.8" ];

  doCheck = true;
  checkTarget = "test";

  # remove files for supporting dracut
  postInstall = ''
    rm -r "$out/lib/dracut"
    rm -r "$out/lib/systemd/system-generators"
  '';

  meta = with lib; {
    description = "Easy to use local storage management for Linux";
    homepage = "https://stratis-storage.github.io";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
