{
  stdenv, fetchurl, lib,
  pkgconfig, libxml2, libxslt,
  dbus-glib, libcap_ng, libqb, libseccomp, polkit, protobuf, audit,
  withGui ? true,
  qtbase ? null,
  qttools ? null,
  qtsvg ? null,
  libgcrypt ? null,
  libsodium ? null
}:

with stdenv.lib;

assert libgcrypt != null -> libsodium == null;

stdenv.mkDerivation rec {
  version = "0.7.4";
  pname = "usbguard";

  repo = "https://github.com/USBGuard/usbguard";

  src = fetchurl {
    url = "${repo}/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "1qkskd6q5cwlh2cpcsbzmmmgk6w63z0825wlb2sjwqq3kfgwjb3k";
  };

  nativeBuildInputs = [
    pkgconfig
    libxslt # xsltproc
    libxml2 # xmllint
  ];

  buildInputs = [
    dbus-glib
    libcap_ng
    libqb
    libseccomp
    polkit
    protobuf
    audit
  ]
  ++ (lib.optional (libgcrypt != null) libgcrypt)
  ++ (lib.optional (libsodium != null) libsodium)
  ++ (lib.optionals withGui [ qtbase qtsvg qttools ]);

  configureFlags = [
    "--with-bundled-catch"
    "--with-bundled-pegtl"
    "--with-dbus"
    "--with-polkit"
  ]
  ++ (lib.optional (libgcrypt != null) "--with-crypto-library=gcrypt")
  ++ (lib.optional (libsodium != null) "--with-crypto-library=sodium")
  ++ (lib.optional withGui "--with-gui-qt=qt5");

  enableParallelBuilding = true;

  meta = {
    description = "The USBGuard software framework helps to protect your computer against BadUSB.";
    homepage = "https://usbguard.github.io/";
    license = licenses.gpl2;
    maintainers = [ maintainers.tnias ];
  };
}
