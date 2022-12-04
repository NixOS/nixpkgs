{ lib, stdenv, util-linux, coreutils, fetchurl, groff, system-sendmail, udev, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "mdadm";
  version = "4.2";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/raid/mdadm/mdadm-${version}.tar.xz";
    sha256 = "sha256-RhwhVnCGS7dKTRo2IGhKorL4KW3/oGdD8m3aVVes8B0=";
  };

  patches = [ ./no-self-references.patch ];

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

  nativeBuildInputs = [ groff makeWrapper ];

  postPatch = ''
    sed -e 's@/lib/udev@''${out}/lib/udev@' \
        -e 's@ -Werror @ @' \
        -e 's@/usr/sbin/sendmail@${system-sendmail}/bin/sendmail@' -i Makefile
    sed -i \
        -e 's@/usr/bin/basename@${coreutils}/bin/basename@g' \
        -e 's@BINDIR/blkid@${util-linux}/bin/blkid@g' \
        *.rules
  '';

  postInstall = ''
    install -D -m 755 misc/mdcheck ''${out}/bin/mdcheck
    wrapProgram $out/bin/mdcheck \
      --prefix PATH : ''${out}/bin:${lib.makeBinPath [ util-linux ]}

    # mdadm's mdmonitor, mdcheck_start & mdcheck_continue units don't have nix
    # paths to the mdcheck script in them as mdadm's Makefile doesn't handle
    # mdcheck path substitutions at all.  Rather than nixifying them though,
    # it makes more sense to remove them and allow same-named units to be
    # configured by a NixOS module, where their configuration options can be
    # properly exposed.  So those modules are removed to avoid naming
    # conflicts.
    rm ''${out}/lib/systemd/system/mdcheck_* ''${out}/lib/systemd/system/mdmonitor*
  '';

  # This is to avoid self-references, which causes the initrd to explode
  # in size and in turn prevents mdraid systems from booting.
  postFixup = ''
    grep -r $out $out/bin && false || true
  '';

  meta = with lib; {
    description = "Programs for managing RAID arrays under Linux";
    homepage = "http://neil.brown.name/blog/mdadm";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ekleog ];
    platforms = platforms.linux;
  };
}
