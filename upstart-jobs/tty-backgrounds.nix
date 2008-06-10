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

  extraEtc = [
    { source = themesUnpacked;
      target = "splash";
    }
  ];

  job = ''
    start on hardware-scan

    start script

	# Critical: tell the kernel where to find splash_helper.  It calls
	# this program every time we switch between consoles.
	echo ${splashutils}/${splashutils.helperName} > ${splashutils.helperProcFile}

	# For each console...
	for tty in ${toString (map (x: x.tty) backgrounds)}; do
	    # Make sure that the console exists.
	    echo -n "" > /dev/tty$tty 

	    # Set the theme as determined by tty-backgrounds-combine.sh
	    # above.
	    theme=$(readlink ${themesUnpacked}/$tty)
	    ${splashutils}/${splashutils.controlName} --tty $tty -c setcfg -t $theme || true
	    ${splashutils}/${splashutils.controlName} --tty $tty -c setpic -t $theme || true
	    ${splashutils}/${splashutils.controlName} --tty $tty -c on || true
	done

    end script

    respawn sleep 10000 # !!! Hack

    stop script
	# Disable the theme on each console.
	for tty in ${toString (map (x: x.tty) backgrounds)}; do
	    ${splashutils}/${splashutils.controlName} --tty $tty -c off || true
	done
    end script
  '';
  
}
