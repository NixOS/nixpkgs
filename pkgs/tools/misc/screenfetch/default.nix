{ stdenv, fetchgit, xdpyinfo, xprop }:

let
  version = "3.6.2";
in
stdenv.mkDerivation {
  name = "screenFetch-${version}";
  pname = "screenfetch";

  src = fetchgit {
    url = git://github.com/KittyKatt/screenFetch.git;
    rev = "dec1cd6c2471defe4459967fbc8ae15b55714338";
    sha256 = "138a7g0za5dq27jx7x8gqg7gjkgyq0017v0nbcg68ys7dqlxsdl3";
  };

  installPhase = ''
    install -Dm 0755 $pname-dev $out/bin/$pname
    install -Dm 0644 $pname.1 $out/man/man1/$pname.1
  '';

  meta = {
    description = "Fetches system/theme information in terminal for Linux desktop screenshots";
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
