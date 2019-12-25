{ stdenv, fetchurl, fetchpatch, libgcrypt, libnl, pkgconfig, python3, wireless-regdb }:

stdenv.mkDerivation rec {
  pname = "crda";
  version = "3.18";

  src = fetchurl {
    sha256 = "1gydiqgb08d9gbx4l6gv98zg3pljc984m50hmn3ysxcbkxkvkz23";
    url = "http://kernel.org/pub/software/network/crda/crda-${version}.tar.xz";
  };

  patches = [
    # Switch to Python 3
    # https://lore.kernel.org/linux-wireless/1437542484-23409-1-git-send-email-ahmed.taahir@gmail.com/
    (fetchpatch {
      url = "https://lore.kernel.org/linux-wireless/1437542484-23409-2-git-send-email-ahmed.taahir@gmail.com/raw";
      sha256 = "0s2n340cgaasvg1k8g9v8xjrbh4y2mcgrhdmv97ja2fs8xjcjbf1";
    })
    (fetchpatch {
      url = "https://lore.kernel.org/linux-wireless/1437542484-23409-3-git-send-email-ahmed.taahir@gmail.com/raw";
      sha256 = "01dlfw7kqhyx025jxq2l75950b181p9r7i9zkflcwvbzzdmx59md";
    })
  ];

  buildInputs = [ libgcrypt libnl ];
  nativeBuildInputs = [
    pkgconfig
    python3
    python3.pkgs.pycrypto
  ];

  postPatch = ''
    patchShebangs utils/
    substituteInPlace Makefile --replace ldconfig true
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

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-const-variable";

  buildFlags = [ "all_noverify" ];
  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "verify";

  postInstall = ''
    # The patch installs build header
    rm $out/include/reglib/keys-gcrypt.h
  '';

  meta = with stdenv.lib; {
    description = "Linux wireless Central Regulatory Domain Agent";
    longDescription = ''
      CRDA acts as the udev helper for communication between the kernel and
      userspace for regulatory compliance. It relies on nl80211 for communication.

      CRDA is intended to be run only through udev communication from the kernel.
      To use it under NixOS, add

        services.udev.packages = [ pkgs.crda ];

      to the system configuration.
    '';
    homepage = http://drvbp1.linux-foundation.org/~mcgrof/rel-html/crda/;
    license = licenses.free; # "copyleft-next 0.3.0", as yet without a web site
    platforms = platforms.linux;
  };
}
