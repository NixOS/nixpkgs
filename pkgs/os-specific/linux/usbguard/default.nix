{
  stdenv, fetchurl, lib,
  libxslt, pandoc, pkgconfig,
  dbus-glib, libcap_ng, libqb, libseccomp, polkit, protobuf, qtbase, qttools, qtsvg,
  libgcrypt ? null,
  libsodium ? null
}:

with stdenv.lib;

assert libgcrypt != null -> libsodium == null;

stdenv.mkDerivation rec {
  version = "0.7.0";
  name = "usbguard-${version}";

  repo = "https://github.com/dkopecek/usbguard";

  src = fetchurl {
    url = "${repo}/releases/download/${name}/${name}.tar.gz";
    sha256 = "1e1485a2b47ba3bde9de2851b371d2552a807047a21e0b81553cf80d7f722709";
  };

  patches = [
    ./daemon_read_only_config.patch
    ./documentation.patch
  ];

  nativeBuildInputs = [
    libxslt
    pandoc # for rendering documentation
    pkgconfig
  ];

  buildInputs = [
    dbus-glib
    libcap_ng
    libqb
    libseccomp
    polkit
    protobuf

    qtbase
    qtsvg
    qttools
  ]
  ++ (lib.optional (libgcrypt != null) libgcrypt)
  ++ (lib.optional (libsodium != null) libsodium);

  configureFlags = [
    "--with-bundled-catch"
    "--with-bundled-pegtl"
    "--with-dbus"
    "--with-gui-qt=qt5"
    "--with-polkit"
  ]
  ++ (lib.optional (libgcrypt != null) "--with-crypto-library=gcrypt")
  ++ (lib.optional (libsodium != null) "--with-crypto-library=sodium");

  enableParallelBuilding = true;

  meta = {
    description = "The USBGuard software framework helps to protect your computer against BadUSB.";
    homepage = "https://dkopecek.github.io/usbguard/";
    license = licenses.gpl2;
    maintainers = [ maintainers.tnias ];
  };
}
