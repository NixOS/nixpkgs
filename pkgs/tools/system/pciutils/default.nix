{ stdenv, fetchurl, pkgconfig, zlib, kmod, which }:

stdenv.mkDerivation rec {
  name = "pciutils-3.4.0"; # with database from 2015-09

  src = fetchurl {
    url = "mirror://kernel/software/utils/pciutils/${name}.tar.xz";
    sha256 = "15liffqvdwbpza210wfqy2y135dvg7sbyqr7gvhyjllgspv8z2gq";
  };

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

