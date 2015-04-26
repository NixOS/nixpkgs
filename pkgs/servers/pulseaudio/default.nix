{ stdenv, fetchurl, pkgconfig, gnum4, libtool
, json_c, libsndfile, gettext, intltool, check

# Optional Dependencies
, xlibs ? null, libcap ? null, valgrind ? null, oss ? null, coreaudio ? null
, alsaLib ? null, esound ? null, glib ? null, gtk3 ? null, gconf ? null
, avahi ? null, libjack2 ? null, libasyncns ? null, lirc ? null, dbus ? null
, sbc ? null, bluez5 ? null, udev ? null, openssl ? null, fftw ? null
, speex ? null, systemd ? null, webrtc-audio-processing ? null

# Database selection
, tdb ? null, gdbm ? null

# Extra options
, prefix ? ""
}:

let
  mkFlag = trueStr: falseStr: cond: name: val:
    if cond == null then null else
      "--${if cond != false then trueStr else falseStr}${name}${if val != null && cond != false then "=${val}" else ""}";
  mkEnable = mkFlag "enable-" "disable-";
  mkWith = mkFlag "with-" "without-";
  mkOther = mkFlag "" "" true;

  shouldUsePkg = pkg: if pkg != null && stdenv.lib.any (x: x == stdenv.system) pkg.meta.platforms then pkg else null;

  libOnly = prefix == "lib";

  hasXlibs = xlibs != null;

  optLibcap = if libOnly then null else shouldUsePkg libcap;
  hasCaps = optLibcap != null || stdenv.isFreeBSD; # Built-in on FreeBSD

  optOss = if libOnly then null else shouldUsePkg oss;
  hasOss = optOss != null || stdenv.isFreeBSD; # Built-in on FreeBSD

  optCoreaudio = if libOnly then null else shouldUsePkg coreaudio;
  optAlsaLib = if libOnly then null else shouldUsePkg alsaLib;
  optEsound = if libOnly then null else shouldUsePkg esound;
  optGlib = if libOnly then null else shouldUsePkg glib;
  optGtk3 = if libOnly || hasXlibs then null else shouldUsePkg gtk3;
  optGconf = if libOnly then null else shouldUsePkg gconf;
  optAvahi = if libOnly then null else shouldUsePkg avahi;
  optLibjack2 = if libOnly then null else shouldUsePkg libjack2;
  optLibasyncns = shouldUsePkg libasyncns;
  optLirc = if libOnly then null else shouldUsePkg lirc;
  optDbus = shouldUsePkg dbus;
  optSbc = if libOnly then null else shouldUsePkg sbc;
  optBluez5 = if optDbus == null || optSbc == null then null
    else shouldUsePkg bluez5;
  optUdev = if libOnly then null else shouldUsePkg udev;
  optOpenssl = if libOnly then null else shouldUsePkg openssl;
  optFftw = if libOnly then null else shouldUsePkg fftw;
  optSpeex = if libOnly then null else shouldUsePkg speex;
  optSystemd = shouldUsePkg systemd;
  optWebrtc-audio-processing = if libOnly then null else shouldUsePkg webrtc-audio-processing;
  hasWebrtc = if libOnly then null else optWebrtc-audio-processing != null;

  # Pick a database to use
  databaseName = if tdb != null then "tdb" else
    if gdbm != null then "gdbm" else "simple";
  database = {
    tdb = tdb;
    gdbm = gdbm;
    simple = null;
  }.${databaseName};
in
stdenv.mkDerivation rec {
  name = "${prefix}pulseaudio-${version}";
  version = "6.0";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/releases/pulseaudio-${version}.tar.xz";
    sha256 = "1xpnfxa0d8pgf6b4qdgnkcvrvdxbbbjd5ync19h0f5hbp3h401mm";
  };

  nativeBuildInputs = [ pkgconfig gnum4 libtool ];
  buildInputs = [
    json_c libsndfile gettext intltool check database

    optLibcap valgrind optOss optCoreaudio optAlsaLib optEsound optGlib
    optGtk3 optGconf optAvahi optLibjack2 optLibasyncns optLirc optDbus optUdev
    optOpenssl optFftw optSpeex optSystemd optWebrtc-audio-processing
  ] ++ stdenv.lib.optionals hasXlibs (with xlibs; [
      libX11 libxcb libICE libSM libXtst xextproto libXi
    ]) ++ stdenv.lib.optionals (optBluez5 != null) [ optBluez5 optSbc ];

  preConfigure = ''
    # Move the udev rules under $(prefix).
    sed -i "src/Makefile.in" \
        -e "s|udevrulesdir[[:blank:]]*=.*$|udevrulesdir = $out/lib/udev/rules.d|g"

   # don't install proximity-helper as root and setuid
   sed -i "src/Makefile.in" \
       -e "s|chown root|true |" \
       -e "s|chmod r+s |true |"
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"

    (mkEnable false                   "atomic-arm-memory-barrier"  null)         # TODO: Enable on armv8
    (mkEnable false                   "neon-opt"                   null)         # TODO: Enable on armv8
    (mkEnable hasXlibs                "x11"                        null)
    (mkWith   hasCaps                 "caps"                       null)
    (mkEnable true                    "tests"                      null)
    (mkEnable false                   "samplerate"                 null)         # Deprecated
    (mkWith   true                    "database"                   databaseName)
    (mkEnable hasOss                  "oss-output"                 null)
    (mkEnable hasOss                  "oss-wrapper"                null)
    (mkEnable (optCoreaudio != null)  "coreaudio-output"           null)
    (mkEnable (optAlsaLib != null)    "alsa"                       null)
    (mkEnable (optEsound != null)     "esound"                     null)
    (mkEnable false                   "solaris"                    null)
    (mkEnable false                   "waveout"                    null)         # Windows Only
    (mkEnable (optGlib != null)       "glib2"                      null)
    (mkEnable (optGtk3 != null)       "gtk3"                       null)
    (mkEnable (optGconf != null)      "gconf"                      null)
    (mkEnable (optAvahi != null)      "avahi"                      null)
    (mkEnable (optLibjack2 != null)   "jack"                       null)
    (mkEnable (optLibasyncns != null) "asyncns"                    null)
    (mkEnable false                   "tcpwrap"                    null)
    (mkEnable (optLirc != null)       "lirc"                       null)
    (mkEnable (optDbus != null)       "dbus"                       null)
    (mkEnable false                   "bluez4"                     null)
    (mkEnable (optBluez5 != null)     "bluez5"                     null)
    (mkEnable (optBluez5 != null)     "bluez5-ofono-headset"       null)
    (mkEnable (optBluez5 != null)     "bluez5-native-headset"      null)
    (mkEnable (optUdev != null)       "udev"                       null)
    (mkEnable false                   "hal-compat"                 null)
    (mkEnable true                    "ipv6"                       null)
    (mkEnable (optOpenssl != null)    "openssl"                    null)
    (mkWith   (optFftw != null)       "fftw"                       null)
    (mkWith   (optSpeex != null)      "speex"                      null)
    (mkEnable false                   "xen"                        null)
    (mkEnable false                   "gcov"                       null)
    (mkEnable (optSystemd != null)    "systemd-daemon"             null)
    (mkEnable (optSystemd != null)    "systemd-login"              null)
    (mkEnable (optSystemd != null)    "systemd-journal"            null)
    (mkEnable true                    "manpages"                   null)
    (mkEnable hasWebrtc               "webrtc-aec"                 null)
    (mkEnable true                    "adrian-aec"                 null)
    (mkWith   true                    "system-user"                "pulseaudio")
    (mkWith   true                    "system-group"               "pulseaudio")
    (mkWith   true                    "access-group"               "audio")
    "--with-systemduserunitdir=\${out}/lib/systemd/user"
  ] ++ stdenv.lib.optional stdenv.isDarwin "--with-mac-sysroot=/";

  enableParallelBuilding = true;

  # not sure what the best practices are here -- can't seem to find a way
  # for the compiler to bring in stdlib and stdio (etc.) properly
  # the alternative is to copy the files from /usr/include to src, but there are
  # probably a large number of files that would need to be copied (I stopped
  # after the seventh)
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin
    "-I/usr/include";

  installFlags = [
    "sysconfdir=$(out)/etc"
    "pulseconfdir=$(out)/etc/pulse"
  ];

  postInstall = stdenv.lib.optionalString libOnly ''
    rm -rf $out/{bin,share,etc,lib/{pulse-*,systemd}}
  '';

  meta = with stdenv.lib; {
    description = "Sound server for POSIX and Win32 systems";
    homepage    = http://www.pulseaudio.org/;
    # Note: Practically, the server is under the GPL due to the
    # dependency on `libsamplerate'.  See `LICENSE' for details.
    licenses    = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 wkennington ];
    platforms   = platforms.unix;

    longDescription = ''
      PulseAudio is a sound server for POSIX and Win32 systems.  A
      sound server is basically a proxy for your sound applications.
      It allows you to do advanced operations on your sound data as it
      passes between your application and your hardware.  Things like
      transferring the audio to a different machine, changing the
      sample format or channel count and mixing several sounds into
      one are easily achieved using a sound server.
    '';
  };
}
