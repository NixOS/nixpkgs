{ stdenv, lib, fetchFromGitHub, makeWrapper, coreutils, gawk, procps, gnused
, bc, findutils, xdpyinfo, xprop, gnugrep, ncurses, pciutils
, darwin
}:

let
  path = lib.makeBinPath ([
    coreutils gawk gnused findutils
    gnugrep ncurses bc pciutils
  ] ++ lib.optionals stdenv.isLinux [
    procps
    xdpyinfo
    xprop
  ] ++ lib.optionals stdenv.isDarwin (with darwin; [
    adv_cmds
    DarwinTools
    system_cmds
    "/usr" # some commands like defaults is not available to us
  ]));

in stdenv.mkDerivation rec {
  pname = "screenfetch";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner  = "KittyKatt";
    repo   = "screenFetch";
    rev    = "v${version}";
    sha256 = "04l8aqr474pb115nagn9f6y48jw92n1qfszgw7dbhgl4mpn95lcr";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm 0755 screenfetch-dev $out/bin/screenfetch
    install -Dm 0644 screenfetch.1 $out/share/man/man1/screenfetch.1
    install -Dm 0644 -t $out/share/doc/screenfetch CHANGELOG COPYING README.mkdn TODO

    # Fix all of the dependencies of screenfetch
    patchShebangs $out/bin/screenfetch
    wrapProgram "$out/bin/screenfetch" \
      --prefix PATH : ${path}
  '';

  meta = with lib; {
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
    license = licenses.gpl3;
    homepage = "https://github.com/KittyKatt/screenFetch";
    maintainers = with maintainers; [ relrod ];
    platforms = platforms.all;
  };
}
