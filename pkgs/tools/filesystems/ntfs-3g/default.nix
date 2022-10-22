{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, gettext, mount, libuuid, kmod, macfuse-stubs, DiskArbitration
, crypto ? false, libgcrypt, gnutls
}:

stdenv.mkDerivation rec {
  pname = "ntfs3g";
  version = "2022.5.17";

  outputs = [ "out" "dev" "man" "doc" ];

  src = fetchFromGitHub {
    owner = "tuxera";
    repo = "ntfs-3g";
    rev = version;
    sha256 = "sha256-xh8cMNIHeJ1rtk5zwOsmcxeedgZ3+MSiWn2UC7y+gtQ=";
  };

  buildInputs = [ gettext libuuid ]
    ++ lib.optionals crypto [ gnutls libgcrypt ]
    ++ lib.optionals stdenv.isDarwin [ macfuse-stubs DiskArbitration ];

  # Note: libgcrypt is listed here non-optionally because its m4 macros are
  # being used in ntfs-3g's configure.ac.
  nativeBuildInputs = [ autoreconfHook libgcrypt pkg-config ];

  patches = [
    # https://github.com/tuxera/ntfs-3g/pull/39
    ./autoconf-sbin-helpers.patch
    ./consistent-sbindir-usage.patch
  ];

  configureFlags = [
    "--disable-ldconfig"
    "--exec-prefix=\${prefix}"
    "--enable-mount-helper"
    "--enable-posix-acls"
    "--enable-xattr-mappings"
    "--${if crypto then "enable" else "disable"}-crypto"
    "--enable-extras"
    "--with-mount-helper=${mount}/bin/mount"
    "--with-umount-helper=${mount}/bin/umount"
  ] ++ lib.optionals stdenv.isLinux [
    "--with-modprobe-helper=${kmod}/bin/modprobe"
  ];

  postInstall =
    ''
      # Prefer ntfs-3g over the ntfs driver in the kernel.
      ln -sv mount.ntfs-3g $out/sbin/mount.ntfs
    '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/tuxera/ntfs-3g";
    description = "FUSE-based NTFS driver with full write support";
    maintainers = with maintainers; [ dezgeg ];
    platforms = with platforms; darwin ++ linux;
    license = with licenses; [
      gpl2Plus # ntfs-3g itself
      lgpl2Plus # fuse-lite
    ];
  };
}
