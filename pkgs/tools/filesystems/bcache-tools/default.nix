{ stdenv, fetchurl, pkgconfig, utillinux, bash }:

stdenv.mkDerivation rec {
  pname = "bcache-tools";
  version = "1.0.7";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "https://github.com/g2p/bcache-tools/archive/v${version}.tar.gz";
    sha256 = "1gbsh2qw0a7kgck6w0apydiy37nnz5xvdgipa0yqrfmghl86vmv4";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ utillinux ];

  # * Remove broken install rules (they ignore $PREFIX) for stuff we don't need
  #   anyway (it's distro specific stuff).
  # * Fixup absolute path to modprobe.
  prePatch = ''
    sed -e "/INSTALL.*initramfs\/hook/d" \
        -e "/INSTALL.*initcpio\/install/d" \
        -e "/INSTALL.*dracut\/module-setup.sh/d" \
        -e "s/pkg-config/$PKG_CONFIG/" \
        -i Makefile
  '';

  patches = [
    ./bcache-udev-modern.patch
    ./fix-static.patch
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "UDEVLIBDIR=${placeholder "out"}/lib/udev/"
  ];

  preBuild = ''
    sed -e "s|/bin/sh|${bash}/bin/sh|" -i *.rules
  '';

  preInstall = ''
    mkdir -p "$out/sbin" "$out/lib/udev/rules.d" "$out/share/man/man8"
  '';

  meta = with stdenv.lib; {
    description = "User-space tools required for bcache (Linux block layer cache)";
    longDescription = ''
      Bcache is a Linux kernel block layer cache. It allows one or more fast
      disk drives such as flash-based solid state drives (SSDs) to act as a
      cache for one or more slower hard disk drives.
      
      This package contains the required user-space tools.

      User documentation is in Documentation/bcache.txt in the Linux kernel
      tree.
    '';
    homepage = "https://bcache.evilpiepirate.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
