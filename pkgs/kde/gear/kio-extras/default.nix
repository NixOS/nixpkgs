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
  xorg,
  kio,
}:
mkKdeDerivation {
  pname = "kio-extras";

  extraNativeBuildInputs = [pkg-config shared-mime-info];
  extraBuildInputs = [
    qt5compat
    qtsvg

    samba
    libssh
    libmtp
    libimobiledevice
    gperf
    libtirpc
    openexr
    taglib
    libappimage
    xorg.libXcursor
  ];

  postInstall = ''
    substituteInPlace $out/share/dbus-1/services/org.kde.kmtpd5.service \
      --replace-fail Exec=$out/libexec/kf6/kiod6 Exec=${kio}/libexec/kf6/kiod6
  '';
}
