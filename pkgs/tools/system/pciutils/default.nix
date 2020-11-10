{ stdenv, fetchurl, pkgconfig, zlib, kmod, which
, static ? stdenv.targetPlatform.isStatic
, darwin ? null
}:

stdenv.mkDerivation rec {
  name = "pciutils-3.7.0"; # with release-date database

  src = fetchurl {
    url = "mirror://kernel/software/utils/pciutils/${name}.tar.xz";
    sha256 = "1ss0rnfsx8gvqjxaji4mvbhf9xyih4cadmgadbwwv8mnx1xvjh4x";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib kmod which ] ++
    stdenv.lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.IOKit;

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

  # Get rid of update-pciids as it won't work.
  postInstall = "rm $out/sbin/update-pciids $out/man/man8/update-pciids.8";

  meta = with stdenv.lib; {
    homepage = "http://mj.ucw.cz/pciutils.html";
    description = "A collection of programs for inspecting and manipulating configuration of PCI devices";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ]; # not really, but someone should watch it
  };
}
