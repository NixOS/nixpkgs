{ lib, stdenv, fetchurl, fetchpatch, libgcrypt, libnl, pkg-config, python3Packages, wireless-regdb }:

stdenv.mkDerivation rec {
  pname = "crda";
  version = "4.14";

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/crda.git/snapshot/crda-${version}.tar.gz";
    sha256 = "sha256-Wo81u4snR09Gaw511FG6kXQz2KqxiJZ4pk2cTnKouMI=";
  };

  patches = [
    # Fix python 3 build: except ImportError, e: SyntaxError: invalid syntax
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/d234fddf451fab0f4fc412e2769f54e11f10d7d8/trunk/crda-4.14-python-3.patch";
      sha256 = "sha256-KEezEKrfizq9k4ZiE2mf3Nl4JiBayhXeVnFl7wYh28Y=";
    })

    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/d48ec843222b0d74c85bce86fa6f087c7dfdf952/trunk/0001-Makefile-Link-libreg.so-against-the-crypto-library.patch";
      sha256 = "sha256-j93oydi209f22OF8aXZ/NczuUOnlhkdSeYvy2WRRvm0=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    python3Packages.m2crypto # only used for a build time script
  ];

  buildInputs = [
    libgcrypt
    libnl
  ];

  postPatch = ''
    patchShebangs utils/
    substituteInPlace Makefile \
      --replace 'gzip' 'gzip -n' \
      --replace ldconfig true \
      --replace pkg-config $PKG_CONFIG
    sed -i crda.c \
      -e "/\/usr\/.*\/regulatory.bin/d" \
      -e "s|/lib/crda|${wireless-regdb}/lib/crda|g"
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SBINDIR=$(out)/bin/"
    "UDEV_RULE_DIR=$(out)/lib/udev/rules.d/"
    "REG_BIN=${wireless-regdb}/lib/crda/regulatory.bin"
  ];

  buildFlags = [ "all_noverify" ];
  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "verify";

  meta = with lib; {
    description = "Linux wireless Central Regulatory Domain Agent";
    longDescription = ''
      CRDA acts as the udev helper for communication between the kernel and
      userspace for regulatory compliance. It relies on nl80211 for communication.

      CRDA is intended to be run only through udev communication from the kernel.
      To use it under NixOS, add

        services.udev.packages = [ pkgs.crda ];

      to the system configuration.
    '';
    homepage = "https://wireless.wiki.kernel.org/en/developers/regulatory/crda";
    license = licenses.free; # "copyleft-next 0.3.0", as yet without a web site
    platforms = platforms.linux;
  };
}
