{ stdenv
, lib
, fetchurl
, autoreconfHook
, autoconf-archive
, pkg-config
, perl
, python3
, dbus
, polkit
, systemdLibs
, IOKit
, pname ? "pcsclite"
, polkitSupport ? false
}:

stdenv.mkDerivation rec {
  inherit pname;
  version = "1.9.5";

  outputs = [ "bin" "out" "dev" "doc" "man" ];

  src = fetchurl {
    url = "https://pcsclite.apdu.fr/files/pcsc-lite-${version}.tar.bz2";
    hash = "sha256-nuP5szNTdWIXeJNVmtT3uNXCPr6Cju9TBWwC2xQEnQg=";
  };

  patches = [ ./no-dropdir-literals.patch ];

  postPatch = ''
    sed -i configure.ac \
      -e "s@polkit_policy_dir=.*@polkit_policy_dir=$bin/share/polkit-1/actions@"
  '';

  configureFlags = [
    "--enable-confdir=/etc"
    # The OS should care on preparing the drivers into this location
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
    (lib.enableFeature stdenv.isLinux "libsystemd")
    (lib.enableFeature polkitSupport "polkit")
  ] ++ lib.optionals stdenv.isLinux [
    "--enable-ipcdir=/run/pcscd"
    "--with-systemdsystemunitdir=${placeholder "bin"}/lib/systemd/system"
  ];

  postConfigure = ''
    sed -i -re '/^#define *PCSCLITE_HP_DROPDIR */ {
      s/(DROPDIR *)(.*)/\1(getenv("PCSCLITE_HP_DROPDIR") ? : \2)/
    }' config.h
  '';

  postInstall = ''
    # pcsc-spy is a debugging utility and it drags python into the closure
    moveToOutput bin/pcsc-spy "$dev"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook autoconf-archive pkg-config perl ];

  buildInputs = [ python3 ]
    ++ lib.optionals stdenv.isLinux [ systemdLibs ]
    ++ lib.optionals stdenv.isDarwin [ IOKit ]
    ++ lib.optionals polkitSupport [ dbus polkit ];

  meta = with lib; {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = "https://pcsclite.apdu.fr/";
    license = licenses.bsd3;
    platforms = with platforms; unix;
  };
}
