{ stdenv, fetchurl, bash }:

stdenv.mkDerivation rec {
  name = "incron-0.5.12";
  src = fetchurl {
    url = "https://github.com/ar-/incron/archive/0.5.12.tar.gz";
    sha256 = "14cgsfyl43pd86wy40m1xwr7ww023n2jyks66ngybz5s4gbhps6c";
  };

  patchPhase = ''
    sed -i "s|PREFIX = /usr/local|PREFIX = $out|g" Makefile
    sed -i "s|/bin/bash|${bash}/bin/bash|g" usertable.cpp
    sed -i "s|/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin|/run/current-system/sw/bin|g" usertable.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin

    # make install doesn't work because setuid and permissions
    # just manually install the binaries instead
    cp incrond incrontab $out/bin/

    # make install-man is fine for documentation
    make install-man
  '';

  meta = with stdenv.lib; {
    description = "
      The inotify cron daemon (incrond) is a daemon which monitors filesystem events and executes commands defined in system and user tables. It's use is generally similar to cron.";
    license = licenses.gpl2;
    homepage = https://github.com/ar-/incron;
    platforms = platforms.linux;
  };
}
