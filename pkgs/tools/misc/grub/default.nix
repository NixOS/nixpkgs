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
  
  patches = [
    # Patch to add primitive splash screen support (not the fancy SUSE gfxmenu stuff).
    # With this you can set splashimage=foo.xpm.gz in menu.lst to get
    # a 640x480, 14-colour background.
    (fetchurl {
      url = "http://cvs.archlinux.org/cgi-bin/viewcvs.cgi/*checkout*/system/grub-gfx/grub-0.97-graphics.patch?rev=HEAD&cvsroot=AUR&only_with_tag=CURRENT&content-type=text/plain";
      sha256 = "0m6min9cbj71kvp0kxkxdq8dx2dwm3dj0rd5sjz5xdl13ihaj5hy";
    })
  ];

  # Autoconf/automake required for the splashimage patch.
  buildInputs = [autoconf automake];

  preConfigure = ''
    autoreconf
  '';
  
}
