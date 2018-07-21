{ stdenv, fetchurl, pkgconfig, zlib, kmod, which }:

stdenv.mkDerivation rec {
  name = "pciutils-3.6.1"; # with database from 2018-06-29

  src = fetchurl {
    url = "mirror://kernel/software/utils/pciutils/${name}.tar.xz";
    sha256 = "1q39hh8scgvqppk1clzjh7yiq5p2r0knv52g3qzmdhsir4f47h7w";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib kmod which ];

  makeFlags = [
    "SHARED=yes"
    "PREFIX=\${out}"
    "STRIP="
    "HOST=${stdenv.hostPlatform.system}"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    "DNS=yes"
  ];

  installTargets = "install install-lib";

  # Get rid of update-pciids as it won't work.
  postInstall = "rm $out/sbin/update-pciids $out/man/man8/update-pciids.8";

  meta = with stdenv.lib; {
    homepage = http://mj.ucw.cz/pciutils.html;
    description = "A collection of programs for inspecting and manipulating configuration of PCI devices";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ]; # not really, but someone should watch it
  };
}
