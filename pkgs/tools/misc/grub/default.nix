{stdenv, fetchurl, autoconf, automake, buggyBiosCDSupport ? true}:

stdenv.mkDerivation {
  name = "grub-0.97-patch-1.12";
  
  src = fetchurl {
    url = ftp://alpha.gnu.org/gnu/grub/grub-0.97.tar.gz;
    md5 = "cd3f3eb54446be6003156158d51f4884";
  };

  # Lots of patches from Gentoo, in particular splash screen support
  # (not the fancy SUSE gfxmenu stuff though).  Also a fix for boot
  # failures on systems with more than 2 GiB RAM, and for booting from
  # ext3 filesystems with 256-byte inodes as well as ext4 filesystems.
  gentooPatches = fetchurl {
    url = mirror://gentoo/distfiles/grub-0.97-patches-1.12.tar.bz2;
    sha256 = "15xc5349hkzl03lbn2cadrmvjrf3s8sn147vv2142cwys9sdzkl0";
  };

  patches = [
    # Properly handle the case of symlinks such as
    # /dev/disk/by-label/bla.  The symlink resolution code in
    # grub-install isn't smart enough.
    ./symlink.patch

    # Provide support for the "savedefault --once" command in the Grub
    # shell.  KDE uses this to allow rebooting into a non-default
    # entry.
    (fetchurl {
      url = http://cvs.mandriva.com/cgi-bin/viewvc.cgi/SPECS/grub/grub-0.97-once.patch?revision=1.3;
      sha256 = "1g5qfn8lvl32h4pggdf7dmjqjpi42jblknzakb5h909fi5i1qyw8";
    })
    
  ] ++ (stdenv.lib.optional buggyBiosCDSupport ./buggybios.patch);

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
