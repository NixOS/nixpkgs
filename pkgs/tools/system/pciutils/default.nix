{ stdenv, fetchurl, pkgconfig, zlib, kmod, which }:

stdenv.mkDerivation rec {
  name = "pciutils-3.5.1"; # with database from 2016-05

  src = fetchurl {
    url = "mirror://kernel/software/utils/pciutils/${name}.tar.xz";
    sha256 = "0byl2f897w5lhs4bvr6p7qwcz9bllj2zyfv7nywbcbsnb9ha9wrb";
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

