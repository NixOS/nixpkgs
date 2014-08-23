{ fetchurl, stdenv, binutils
, pkgconfig, gtk, glib, pango, libglade }:

stdenv.mkDerivation rec {
  name = "sysprof-1.2.0";

  src = fetchurl {
    url = "http://www.sysprof.com/sysprof-1.2.0.tar.gz";
    sha256 = "1wb4d844rsy8qjg3z5m6rnfm72da4xwzrrkkb1q5r10sq1pkrw5s";
  };

  buildInputs = [ binutils pkgconfig gtk glib pango libglade ];

  meta = {
    homepage = http://sysprof.com/;
    description = "Sysprof, a system-wide profiler for Linux";
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription = ''
      Sysprof is a sampling CPU profiler for Linux that uses the perf_event_open
      system call to profile the entire system, not just a single
      application.  Sysprof handles shared libraries and applications
      do not need to be recompiled.  In fact they don't even have to
      be restarted.
    '';
  };
}
