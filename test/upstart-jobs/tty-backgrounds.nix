{stdenv, splashutils, backgrounds}:

rec {
  name = "tty-backgrounds";

  unpackTheme = theme: import ../helpers/unpack-theme.nix {
    inherit stdenv theme;
  };

  themesUnpacked = stdenv.mkDerivation {
    name = "splash-themes";
    builder = ./tty-backgrounds-combine.sh;
    # !!! Should use XML here.
    ttys = map (x: x.tty) backgrounds;
    themes = map (x: if x ? theme then (unpackTheme x.theme) else "default") backgrounds;
  };

  job = "
start on hardware-scan

start script

    rm -f /etc/splash
    ln -s ${themesUnpacked} /etc/splash

    # Critical: tell the kernel where to find splash_helper.  It calls
    # this program every time we switch between consoles.
    echo ${splashutils}/bin/splash_helper > /proc/sys/kernel/fbsplash

    # Set the theme for each console, as determined by
    # tty-backgrounds-combine.sh above.
    for tty in ${toString (map (x: x.tty) backgrounds)}; do
        theme=$(readlink ${themesUnpacked}/$tty)
        ${splashutils}/bin/splash_util --tty $tty -c setcfg -t $theme || true
        ${splashutils}/bin/splash_util --tty $tty -c setpic -t $theme || true
        ${splashutils}/bin/splash_util --tty $tty -c on || true
    done

end script

respawn sleep 10000 # !!! Hack

stop script
    # Disable the theme on each console.
    for tty in ${toString (map (x: x.tty) backgrounds)}; do
        ${splashutils}/bin/splash_util --tty $tty -c off || true
    done
end script

  ";
  
}
