{ stdenv, fetchFromGitHub, makeWrapper, coreutils, gawk, procps, gnused
, bc, findutils, xdpyinfo, xprop, gnugrep, ncurses
}:

stdenv.mkDerivation {
  name = "screenFetch-2016-10-11";

  src = fetchFromGitHub {
    owner = "KittyKatt";
    repo = "screenFetch";
    rev = "89e51f24018c89b3647deb24406a9af3a78bbe99";
    sha256 = "0i2k261jj2s4sfhav7vbsd362pa0gghw6qhwafhmicmf8hq2a18v";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm 0755 screenfetch-dev $out/bin/screenfetch
    install -Dm 0644 screenfetch.1 $out/man/man1/screenfetch.1

    # Fix all of the depedencies of screenfetch
    patchShebangs $out/bin/screenfetch
    wrapProgram "$out/bin/screenfetch" \
      --set PATH ${stdenv.lib.makeBinPath [
        coreutils gawk procps gnused findutils xdpyinfo
        xprop gnugrep ncurses bc
      ]}
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
