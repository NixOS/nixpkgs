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
    # Fixes build on musl
    (fetchurl {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/e58d2b17d3c40faffc0d426aab00184f28d9dafa/srcpkgs/mdadm/patches/musl.patch";
      hash = "sha256-TIcQs+8RM5Q6Z8MHkI50kaJd7f9WdS/EVI16F7b2+SA=";
    })
    # Fixes build on musl 1.2.5+
    (fetchurl {
      url = "https://lore.kernel.org/linux-raid/20240220165158.3521874-1-raj.khem@gmail.com/raw";
      hash = "sha256-JOZ8n7zi+nq236NPpB4e2gUy8I3l3DbcoLhpeL73f98=";
    })
    (fetchurl {
      url = "https://github.com/md-raid-utilities/mdadm/commit/9dbd11e091f84eb0bf9d717283774816c4c4453d.patch";
      hash = "sha256-8GdjP1ceVwejTOFXcHXG8wkIF9/D6hOUGD6btvuqs24=";
    })
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
