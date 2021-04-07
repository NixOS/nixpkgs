{ lib, stdenv, fetchurl, pkg-config, zlib, kmod, which
, hwdata
, static ? stdenv.hostPlatform.isStatic
, IOKit
}:

stdenv.mkDerivation rec {
  name = "pciutils-3.7.0"; # with release-date database

  src = fetchurl {
    url = "mirror://kernel/software/utils/pciutils/${name}.tar.xz";
    sha256 = "1ss0rnfsx8gvqjxaji4mvbhf9xyih4cadmgadbwwv8mnx1xvjh4x";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib kmod which ] ++
    lib.optional stdenv.hostPlatform.isDarwin IOKit;

  preConfigure = if stdenv.cc.isGNU then null else ''
    substituteInPlace Makefile --replace 'CC=$(CROSS_COMPILE)gcc' ""
  '';

  makeFlags = [
    "SHARED=${if static then "no" else "yes"}"
    "PREFIX=\${out}"
    "STRIP="
    "HOST=${stdenv.hostPlatform.system}"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    "DNS=yes"
  ];

  installTargets = [ "install" "install-lib" ];

  postInstall = ''
    # Remove update-pciids as it won't work on nixos
    rm $out/sbin/update-pciids $out/man/man8/update-pciids.8

    # use database from hwdata instead
    # (we don't create a symbolic link because we do not want to pull in the
    # full closure of hwdata)
    cp --reflink=auto ${hwdata}/share/hwdata/pci.ids $out/share/pci.ids
  '';

  meta = with lib; {
    homepage = "http://mj.ucw.cz/pciutils.html";
    description = "A collection of programs for inspecting and manipulating configuration of PCI devices";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ]; # not really, but someone should watch it
  };
}
