{ lib, stdenv, fetchurl, pkg-config, zlib, kmod, which
, hwdata
, static ? stdenv.hostPlatform.isStatic
, IOKit
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "pciutils";
  version = "3.9.0"; # with release-date database

  src = fetchurl {
    url = "mirror://kernel/software/utils/pciutils/pciutils-${version}.tar.xz";
    sha256 = "sha256-zep66XI53uIySaCcaKGaKHo/EJ++ssIy67YWyzhZkBI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ which zlib ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ IOKit ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ kmod ];

  preConfigure = lib.optionalString (!stdenv.cc.isGNU) ''
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

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://github.com/pciutils/pciutils.git";
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://mj.ucw.cz/sw/pciutils/";
    description = "A collection of programs for inspecting and manipulating configuration of PCI devices";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ]; # not really, but someone should watch it
  };
}
