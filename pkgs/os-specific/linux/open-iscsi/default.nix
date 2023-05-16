{ stdenv
, lib
, fetchFromGitHub
, meson
, pkg-config
, ninja
, perl
, util-linux
, open-isns
, openssl
, kmod
, systemd
, runtimeShell
, nixosTests }:

stdenv.mkDerivation rec {
  pname = "open-iscsi";
<<<<<<< HEAD
  version = "2.1.9";
=======
  version = "2.1.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-iscsi";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-y0NIb/KsKpCd8byr/SXI7nwTKXP2/bSSoW8QgeL5xdc=";
=======
    hash = "sha256-JzSyX9zvUkhCEpNwTMneTZpCRgaYxHZ1wP215YnMI78=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    perl
  ];
  buildInputs = [
    kmod
    (lib.getLib open-isns)
    openssl
    systemd
    util-linux
  ];

  preConfigure = ''
    patchShebangs .
  '';

  prePatch = ''
    substituteInPlace etc/systemd/iscsi-init.service.template \
      --replace /usr/bin/sh ${runtimeShell}
    sed -i '/install_dir: db_root/d' meson.build
  '';

  mesonFlags = [
    "-Discsi_sbindir=${placeholder "out"}/sbin"
    "-Drulesdir=${placeholder "out"}/etc/udev/rules.d"
    "-Dsystemddir=${placeholder "out"}/lib/systemd"
    "-Ddbroot=/etc/iscsi"
  ];

<<<<<<< HEAD
  passthru.tests = { inherit (nixosTests) iscsi-root; };
=======
  passthru.tests = { inherit (nixosTests) iscsi-root iscsi-multipath-root; };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A high performance, transport independent, multi-platform implementation of RFC3720";
    license = licenses.gpl2Plus;
    homepage = "https://www.open-iscsi.com";
    platforms = platforms.linux;
    maintainers = with maintainers; [ cleverca22 zaninime ];
  };
}
