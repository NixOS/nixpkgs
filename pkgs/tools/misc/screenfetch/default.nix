{ stdenv, fetchgit, xdpyinfo, xprop }:

let
  version = "2014-05-27";
in
stdenv.mkDerivation {
  name = "screenFetch-${version}";
  pname = "screenfetch";

  src = fetchgit {
    url = git://github.com/KittyKatt/screenFetch.git;
    rev = "69c46cb94b5765dbcb36905c5a35c42eb8e6e470";
    sha256 = "0479na831120bpyrg5nb3nb1jr8p8ahkixk1znwg730q3vdcjd6j";
  };

  installPhase = ''
    install -Dm 0755 $pname-dev $out/bin/$pname
    install -Dm 0644 $pname.1 $out/man/man1/$pname.1
  '';

  meta = {
    description = "Fetches system/theme information in terminal for Linux desktop screenshots.";
    longDescription = ''
    screenFetch is a "Bash Screenshot Information Tool". This handy Bash
    script can be used to generate one of those nifty terminal theme
    information + ASCII distribution logos you see in everyone's screenshots
    nowadays. It will auto-detect your distribution and display an ASCII
    version of that distribution's logo and some valuable information to the
    right. There are options to specify no ascii art, colors, taking a
    screenshot upon displaying info, and even customizing the screenshot
    command! This script is very easy to add to and can easily be extended.
    '';
    license = stdenv.lib.licenses.gpl3;
    homepage = http://git.silverirc.com/cgit.cgi/screenfetch-dev.git/;
    maintainers = with stdenv.lib.maintainers; [relrod];
    platforms = stdenv.lib.platforms.all;
  };
}
