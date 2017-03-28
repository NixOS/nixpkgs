{stdenv, fetchurl, fetchpatch, utillinux, libuuid
, crypto ? false, libgcrypt, gnutls, pkgconfig}:

stdenv.mkDerivation rec {
  pname = "ntfs-3g";
  version = "2016.2.22";
  name = "${pname}-${version}";

  buildInputs = [ libuuid ] ++ stdenv.lib.optionals crypto [ gnutls libgcrypt ];
  nativeBuildInputs = stdenv.lib.optional crypto pkgconfig;

  src = fetchurl {
    url = "http://tuxera.com/opensource/ntfs-3g_ntfsprogs-${version}.tgz";
    sha256 = "180y5y09h30ryf2vim8j30a2npwz1iv9ly5yjmh3wjdkwh2jrdyp";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/n/ntfs-3g/1:2016.2.22AR.1-4/debian/patches/0003-CVE-2017-0358.patch";
      sha256 = "0hd05q9q06r18k8pmppvch1sslzqln5fvqj51d5r72g4mnpavpj3";
    })
  ];

  patchPhase = ''
    substituteInPlace src/Makefile.in --replace /sbin '@sbindir@'
    substituteInPlace ntfsprogs/Makefile.in --replace /sbin '@sbindir@'
    substituteInPlace libfuse-lite/mount_util.c \
      --replace /bin/mount ${utillinux}/bin/mount \
      --replace /bin/umount ${utillinux}/bin/umount
  '';

  configureFlags = [
    "--disable-ldconfig"
    "--exec-prefix=\${prefix}"
    "--enable-mount-helper"
    "--enable-posix-acls"
    "--enable-xattr-mappings"
    "--${if crypto then "enable" else "disable"}-crypto"
  ];

  postInstall =
    ''
      # Prefer ntfs-3g over the ntfs driver in the kernel.
      ln -sv mount.ntfs-3g $out/sbin/mount.ntfs
    '';

  meta = with stdenv.lib; {
    homepage = http://www.tuxera.com/community/open-source-ntfs-3g/;
    description = "FUSE-based NTFS driver with full write support";
    maintainers = with maintainers; [ dezgeg ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus; # and (lib)fuse-lite under LGPL2+
  };
}
