{stdenv, fetchurl, utillinux}:

stdenv.mkDerivation rec {
  pname = "ntfs-3g";
  version = "2011.4.12";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/ntfs-3g/ntfs-3g-2010.10.2.tgz/91405690f25822142cdcb43d03e62d3f/ntfs-3g-2010.10.2.tgz";
    sha256 = "0wcyks4nvi1kck8i2dgwfsy5zxhil0v0xam8zbg1p592xbqygiqp";
  };

  preConfigure = ''
    substituteInPlace src/Makefile.in --replace /sbin '@sbindir@' 
    substituteInPlace libfuse-lite/mount_util.c \
      --replace /bin/mount ${utillinux}/bin/mount \
      --replace /bin/umount ${utillinux}/bin/umount
  '';

  configureFlags = "--disable-ldconfig --exec-prefix=\${prefix} --enable-mount-helper";

  postInstall =
    ''
      # Prefer ntfs-3g over the ntfs driver in the kernel.
      ln -s mount.ntfs-3g $out/sbin/mount.ntfs
    '';

  meta = {
    homepage = http://www.tuxera.com/community/;
    description = "FUSE-base NTFS driver with full write support";
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
