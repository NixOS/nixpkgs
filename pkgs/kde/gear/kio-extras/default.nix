{
  mkKdeDerivation,
  qt5compat,
  qtsvg,
  pkg-config,
  samba,
  libssh,
  libmtp,
  libimobiledevice,
  gperf,
  libtirpc,
  openexr,
  taglib,
  shared-mime-info,
  libappimage,
  libxcursor,
  kio,
  lib,
  stdenv,
}:
mkKdeDerivation {
  pname = "kio-extras";

  extraNativeBuildInputs = [
    pkg-config
    gperf
    shared-mime-info
  ];
  extraBuildInputs = [
    qt5compat
    qtsvg

    samba
    libssh
    libmtp
    libimobiledevice
    gperf
    openexr
    taglib
  ]
  ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
    libappimage
    libtirpc
    libxcursor
  ];

  postInstall = ''
    if [ -f $out/share/dbus-1/services/org.kde.kmtpd5.service ]; then
      substituteInPlace $out/share/dbus-1/services/org.kde.kmtpd5.service \
        --replace-fail Exec=$out/libexec/kf6/kiod6 Exec=${kio}/libexec/kf6/kiod6
    fi
  '';

  meta.platforms = lib.platforms.unix;
}
