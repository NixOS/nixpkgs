{ lib, stdenv, util-linux, coreutils, fetchurl, groff, system-sendmail, udev }:

stdenv.mkDerivation rec {
  pname = "mdadm";
  version = "4.3";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/raid/mdadm/mdadm-${version}.tar.xz";
    sha256 = "sha256-QWcnrh8QgOpuMJDOo23QdoJvw2kVHjarc2VXupIZb58=";
  };

  patches = [
    ./no-self-references.patch
    ./fix-hardcoded-mapdir.patch
  ];

  makeFlags = [
    "NIXOS=1" "INSTALL=install" "BINDIR=$(out)/sbin"
    "SYSTEMD_DIR=$(out)/lib/systemd/system"
    "MANDIR=$(out)/share/man" "RUN_DIR=/dev/.mdadm"
    "STRIP="
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  installFlags = [ "install-systemd" ];

  enableParallelBuilding = true;

  buildInputs = [ udev ];

  nativeBuildInputs = [ groff ];

  postPatch = ''
    sed -e 's@/lib/udev@''${out}/lib/udev@' \
        -e 's@ -Werror @ @' \
        -e 's@/usr/sbin/sendmail@${system-sendmail}/bin/sendmail@' -i Makefile
    sed -i \
        -e 's@/usr/bin/basename@${coreutils}/bin/basename@g' \
        -e 's@BINDIR/blkid@${util-linux}/bin/blkid@g' \
        *.rules
  '';

  # This is to avoid self-references, which causes the initrd to explode
  # in size and in turn prevents mdraid systems from booting.
  postFixup = ''
    grep -r $out $out/bin && false || true
  '';

  meta = with lib; {
    description = "Programs for managing RAID arrays under Linux";
    homepage = "https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git";
    license = licenses.gpl2;
    mainProgram = "mdadm";
    maintainers = with maintainers; [ ekleog ];
    platforms = platforms.linux;
  };
}
