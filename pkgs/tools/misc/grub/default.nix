{stdenv, fetchurl, autoconf, automake}:

if stdenv.system == "x86_64-linux" then
  abort "Grub doesn't build on x86_64-linux.  You should use the build for i686-linux instead."
else

stdenv.mkDerivation {
  name = "grub-0.97";
  
  src = fetchurl {
    url = ftp://alpha.gnu.org/gnu/grub/grub-0.97.tar.gz;
    md5 = "cd3f3eb54446be6003156158d51f4884";
  };

  # Lots of patches from Gentoo, in particular splash screen support
  # (not the fancy SUSE gfxmenu stuff though).  Also a fix for boot
  # failures on systems with more than 2 GiB RAM.
  gentooPatches = fetchurl {
    url = mirror://gentoo/distfiles/grub-0.97-patches-1.4.tar.bz2;
    sha256 = "1nki5q1b61ahxcmnw6mq7b8ghcysri4lj7q6dx8iqixrvrpxj399";
  };

  # Autoconf/automake required for the splashimage patch.
  buildInputs = [autoconf automake];

  preConfigure = ''
    unpackFile $gentooPatches
    rm patch/400_all_grub-0.97-reiser4-20050808-gentoo.patch
    for i in patch/*.patch; do
      echo "applying patch $i"
      patch -p1 < $i || patch -p0 < $i
    done
    autoreconf
  '';
}
