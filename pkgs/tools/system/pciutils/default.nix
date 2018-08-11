{ stdenv, fetchurl, pkgconfig, zlib, kmod, which }:

stdenv.mkDerivation rec {
  name = "pciutils-3.6.0"; # with database from 2018-06-29

  src = fetchurl {
    url = "mirror://kernel/software/utils/pciutils/${name}.tar.xz";
    sha256 = "17g9rvjknj2yqwxldnz8m5kaabbdvkcjnfic4sbx88kh0s81197j";
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

  # Use standardized and equivalent realpath(path, NULL) instead of canonicalize_file_name(path).
  # This is documented to be equivalent, see `man 3 canonicalize_file_name`.
  # Fixes w/musl.
  # Upstream PR: https://github.com/pciutils/pciutils/pull/6
  postPatch = ''
    substituteInPlace lib/sysfs.c \
      --replace "canonicalize_file_name(path)" \
                "realpath(path, NULL)"
  '';

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
