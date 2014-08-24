{stdenv, fetchurl, utillinux, libuuid
, crypto ? false, libgcrypt, gnutls, pkgconfig}:

stdenv.mkDerivation rec {
  pname = "ntfs-3g";
  version = "2014.2.15";
  name = "${pname}-${version}";

  buildInputs = [libuuid] ++ stdenv.lib.optionals crypto [gnutls libgcrypt];
  nativeBuildInputs = stdenv.lib.optional crypto pkgconfig;

  src = fetchurl {
    url = "http://tuxera.com/opensource/ntfs-3g_ntfsprogs-${version}.tgz";
    sha256 = "0mjv98m2j0kdzkjiqd2ra1akhb8milx8nwcx7hd26jxi1i09jc2c";
  };

  patchPhase = ''
    substituteInPlace src/Makefile.in --replace /sbin '@sbindir@'
    substituteInPlace ntfsprogs/Makefile.in --replace /sbin '@sbindir@'
    substituteInPlace libfuse-lite/mount_util.c \
      --replace /bin/mount ${utillinux}/bin/mount \
      --replace /bin/umount ${utillinux}/bin/umount
  '';

  configureFlags =
    ''
      --disable-ldconfig --exec-prefix=''${prefix} --enable-mount-helper
      --enable-posix-acls --enable-xattr-mappings --${if crypto then "enable" else "disable"}-crypto
    '';

  postInstall =
    ''
      # Prefer ntfs-3g over the ntfs driver in the kernel.
      ln -sv mount.ntfs-3g $out/sbin/mount.ntfs
    '';

  meta = with stdenv.lib; {
    homepage = http://www.tuxera.com/community/;
    description = "FUSE-base NTFS driver with full write support";
    maintainers = [ maintainers.urkud ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus; # and (lib)fuse-lite under LGPL2+
  };
}

