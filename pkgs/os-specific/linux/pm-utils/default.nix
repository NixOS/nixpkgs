{ lib, stdenv, fetchurl, coreutils, gnugrep, util-linux, kmod
, procps, kbd, dbus }:

let

  binPath = lib.makeBinPath
    [ coreutils gnugrep util-linux kmod procps kbd dbus ];

  sbinPath = lib.makeSearchPathOutput "bin" "sbin"
    [ procps ];

in

stdenv.mkDerivation rec {
  pname = "pm-utils";
  version = "1.4.1";

  src = fetchurl {
    url = "https://pm-utils.freedesktop.org/releases/pm-utils-${version}.tar.gz";
    sha256 = "02qc6zaf7ams6qcc470fwb6jvr4abv3lrlx16clqpn36501rkn4f";
  };

  configureFlags = [ "--sysconfdir=/etc" ];

  preConfigure =
    ''
      # Install the manpages (xmlto isn't really needed).
      substituteInPlace man/Makefile.in --replace '@HAVE_XMLTO_TRUE@' ""

      # Set the PATH properly.
      substituteInPlace pm/pm-functions.in --replace '/sbin:/usr/sbin:/bin:/usr/bin' '$PATH:${binPath}:${sbinPath}'

      substituteInPlace src/pm-action.in --replace 'tr ' '${coreutils}/bin/tr '

      substituteInPlace pm/sleep.d/00logging --replace /bin/uname "$(type -P uname)"

      substituteInPlace pm/sleep.d/90clock --replace /sbin/hwclock hwclock
    '';

  postInstall =
    ''
      # Remove some hooks that have doubtful usefulness.  See
      # http://zinc.canonical.com/~cking/power-benchmarking/pm-utils-results/results.txt.
      # In particular, journal-commit breaks things if you have
      # read-only bind mounts, since it ends up remounting the
      # underlying filesystem read-only.
      rm $out/lib/pm-utils/power.d/{journal-commit,readahead}
    '';

  meta = {
    homepage = "https://pm-utils.freedesktop.org/wiki/";
    description = "A small collection of scripts that handle suspend and resume on behalf of HAL";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
