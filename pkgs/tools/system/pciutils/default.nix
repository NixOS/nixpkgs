{ stdenv, fetchurl, pkgconfig, zlib, kmod, which }:

stdenv.mkDerivation rec {
  name = "pciutils-3.5.2"; # with database from 2016-10

  src = fetchurl {
    url = "mirror://kernel/software/utils/pciutils/${name}.tar.xz";
    sha256 = "1z2y4f3cyvm7a0dyan0n6jpb3p9pvh35lrim0058slj0kwd1969s";
  };

  patches = [ ./module-dir.diff ];

  buildInputs = [ pkgconfig zlib kmod which ];

  makeFlags = "SHARED=yes PREFIX=\${out}";

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

