{stdenv, fetchurl, autoconf, automake}:

stdenv.mkDerivation {
  name = "grub-0.97-patch-1.7";
  
  src = fetchurl {
    url = ftp://alpha.gnu.org/gnu/grub/grub-0.97.tar.gz;
    md5 = "cd3f3eb54446be6003156158d51f4884";
  };

  # Lots of patches from Gentoo, in particular splash screen support
  # (not the fancy SUSE gfxmenu stuff though).  Also a fix for boot
  # failures on systems with more than 2 GiB RAM, and for booting from
  # ext3 filesystems with 256-byte inodes. 
  gentooPatches = fetchurl {
    url = mirror://gentoo/distfiles/grub-0.97-patches-1.7.tar.bz2;
    sha256 = "12akcbp1a31pxzsxm01scgir0fqkk8qqqwhs44vzgs2chzzigyvd";
  };

  patches = [
    # Properly handle the case of symlinks such as
    # /dev/disk/by-label/bla.  The symlink resolution code in
    # grub-install isn't smart enough.
    ./symlink.patch
  ];

  # Autoconf/automake required for the splashimage patch.
  buildInputs = [autoconf automake];

  prePatch = ''
    unpackFile $gentooPatches
    rm patch/400_all_grub-0.97-reiser4-20050808-gentoo.patch
    for i in patch/*.patch; do
      echo "applying patch $i"
      patch -p1 < $i || patch -p0 < $i
    done
  '';

  preConfigure = ''
    autoreconf
  '';
}
