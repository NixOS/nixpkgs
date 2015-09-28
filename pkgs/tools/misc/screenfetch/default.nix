{ stdenv, fetchgit, makeWrapper
, coreutils, gawk, procps, gnused, findutils, xdpyinfo, xprop, gnugrep
}:

stdenv.mkDerivation {
  name = "screenFetch-2015-04-20";

  src = fetchgit {
    url = git://github.com/KittyKatt/screenFetch.git;
    rev = "53e1c0cccacf648e846057938a68dda914f532a1";
    sha256 = "1wyvy1sn7vnclwrzd32jqlq6iirjkhp2ak55brhkpp9rj1qxk3q6";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm 0755 screenfetch-dev $out/bin/screenfetch
    install -Dm 0644 screenfetch.1 $out/man/man1/screenfetch.1

    # Fix all of the depedencies of screenfetch
    patchShebangs $out/bin/screenfetch
    wrapProgram "$out/bin/screenfetch" \
      --set PATH : "" \
      --prefix PATH : "${coreutils}/bin" \
      --prefix PATH : "${gawk}/bin" \
      --prefix PATH : "${procps}/bin" \
      --prefix PATH : "${gnused}/bin" \
      --prefix PATH : "${findutils}/bin" \
      --prefix PATH : "${xdpyinfo}/bin" \
      --prefix PATH : "${xprop}/bin" \
      --prefix PATH : "${gnugrep}/bin"
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
