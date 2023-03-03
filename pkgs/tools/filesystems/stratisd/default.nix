{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, asciidoc
, ncurses
, glibc
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
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "stratisd";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PM+griFtuFT9g+Pqx33frWrucVCXSzfyWAJJXAzrMtI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-P5GKMNifnEvGcsg0hGZn6hg3/S44fUIzqf5Qjp4R/EM=";
  };

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
    ncurses # tput
  ];

  buildInputs = [
    glibc
    glibc.static
    dbus
    cryptsetup
    util-linux
    udev
  ];

  EXECUTABLES_PATHS = lib.makeBinPath ([
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
