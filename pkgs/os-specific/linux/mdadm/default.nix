{ stdenv, writeScript
, fetchurl, groff
, buildPlatform, hostPlatform
}:

let
  sendmail-script = writeScript "sendmail-script" ''
    #!/bin/sh

    if [ -x /run/wrappers/bin/sendmail ]; then
      /run/wrappers/bin/sendmail "$@"
    else
      /run/current-system/sw/bin/sendmail "$@"
    fi
  '';
in
stdenv.mkDerivation rec {
  name = "mdadm-4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/raid/mdadm/${name}.tar.xz";
    sha256 = "1ad3mma641946wn5lsllwf0lifw9lps34fv1nnkhyfpd9krffshx";
  };

  # This is to avoid self-references, which causes the initrd to explode
  # in size and in turn prevents mdraid systems from booting.
  allowedReferences = [ stdenv.cc.libc.out sendmail-script ];

  patches = [ ./no-self-references.patch ];

  makeFlags = [
    "NIXOS=1" "INSTALL=install" "INSTALL_BINDIR=$(out)/sbin"
    "MANDIR=$(out)/share/man" "RUN_DIR=/dev/.mdadm"
    "STRIP="
  ] ++ stdenv.lib.optionals (hostPlatform != buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  nativeBuildInputs = [ groff ];

  preConfigure = ''
    sed -e 's@/lib/udev@''${out}/lib/udev@' \
        -e 's@ -Werror @ @' \
        -e 's@/usr/sbin/sendmail@${sendmail-script}@' -i Makefile
  '';

  meta = with stdenv.lib; {
    description = "Programs for managing RAID arrays under Linux";
    homepage = http://neil.brown.name/blog/mdadm;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
