{ lib, stdenv, fetchFromGitHub, pkg-config, util-linux, bash }:

stdenv.mkDerivation rec {
  pname = "bcache-tools";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "g2p";
    repo = "bcache-tools";
    rev = "v${version}";
    hash = "sha256-6gy0ymecMgEHXbwp/nXHlrUEeDFnmFXWZZPlzP292g4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ util-linux ];

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

  preInstall = ''
    mkdir -p "$out/sbin" "$out/lib/udev/rules.d" "$out/share/man/man8"
  '';

  meta = with lib; {
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
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
