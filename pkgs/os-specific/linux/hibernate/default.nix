{ stdenv, fetchurl, gawk }:

let version = "1.98.1";
in
  stdenv.mkDerivation rec {
    name = "hibernate-${version}";
    src = fetchurl {
      url = "http://www.tuxonice.net/downloads/all/hibernate-script-${version}.tar.gz";
      sha256 = "1xpc2i16jczc3nhvxlkn6fb044srqrh528gnp92cwy4hxf2nzi1z";
    };

    patches = [ ./install.patch ./gen-manpages.patch ./hibernate.patch ];

    buildInputs = [ gawk ];

    installPhase = ''
      # FIXME: Storing config files under `$out/etc' is not very useful.

      substituteInPlace "hibernate.sh" --replace \
        'SWSUSP_D="/etc/hibernate"' "SWSUSP_D=\"$out/etc/hibernate\""

      # Remove all references to `/bin' and `/sbin'.
      for i in scriptlets.d/*
      do
        substituteInPlace "$i" --replace "/bin/" "" --replace "/sbin/" ""
      done

      PREFIX="$out" CONFIG_PREFIX="$out" ./install.sh

      ln -s "$out/share/hibernate/scriptlets.d" "$out/etc/hibernate"
    '';

    meta = {
      description = "The `hibernate' script for swsusp and Tux-on-Ice";
      longDescription = ''
        This package provides the `hibernate' script, a command-line utility
	that saves the computer's state to disk and switches it off, turning
	it into "hibernation".  It works both with Linux swsusp and Tux-on-Ice.
      '';

      license = "GPLv2+";
      homepage = http://www.tuxonice.net/;
    };
  }
