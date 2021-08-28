{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook
, alsaLib, bluez, glib, sbc, dbus

# optional, but useful utils
, readline, libbsd, ncurses

# optional codecs
, aacSupport ? true, fdk_aac
# TODO: aptxSupport
}:

with lib;

stdenv.mkDerivation rec {
  pname = "bluez-alsa";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "Arkq";
    repo = "bluez-alsa";
    rev = "v${version}";
    sha256 = "1jlsgxyqfhncfhx1sy3ry0dp6p95kd4agh7g2b7g51h0c4cv74h8";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [
    alsaLib bluez glib sbc dbus
    readline libbsd ncurses
  ]
  ++ optional aacSupport fdk_aac;

  configureFlags = [
    "--with-alsaplugindir=${placeholder "out"}/lib/alsa-lib"
    "--with-dbusconfdir=${placeholder "out"}/share/dbus-1/system.d"
    "--enable-rfcomm"
    "--enable-hcitop"
  ]
  ++ optional aacSupport "--enable-aac";

  meta = {
    description = "Bluez 5 Bluetooth Audio ALSA Backend";
    longDescription = ''
      Bluez-ALSA (BlueALSA) is an ALSA backend for Bluez 5 audio interface.
      Bluez-ALSA registers all Bluetooth devices with audio profiles in Bluez
      under a virtual ALSA PCM device called `bluealsa` that supports both
      playback and capture.

      Some backstory: Bluez 5 removed built-in support for ALSA in favor of a
      generic interface for 3rd party appliations. Thereafter, PulseAudio
      implemented a backend for that interface and became the only way to get
      Bluetooth audio with Bluez 5. Users prefering ALSA stayed on Bluez 4.
      However, Bluez 4 eventually became deprecated.

      This package is a rebirth of a direct interface between ALSA and Bluez 5,
      that, unlike PulseAudio, provides KISS near-metal-like experience. It is
      not possible to run BluezALSA and PulseAudio Bluetooth at the same time
      due to limitations in Bluez, but it is possible to run PulseAudio over
      BluezALSA if you disable `bluetooth-discover` and `bluez5-discover`
      modules in PA and configure it to play/capture sound over `bluealsa` PCM.
    '';
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.oxij maintainers.lheckemann ];
  };

}
