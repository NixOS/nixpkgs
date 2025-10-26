{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "sleepwatcher";
  version = "2.2.1";

  src = fetchurl {
    url = "https://www.bernhard-baehr.de/sleepwatcher_${version}.tgz";
    sha256 = "0gk4x4x04wz7y0kp19p1jjcxhqqk9n29l4dw3wa72y0n09knbwab";
  };

  sourceRoot = "sleepwatcher_${version}/sources";

  buildPhase = ''
    # Modern build: x86_64 and arm64 only (skip obsolete i386)
    if [ "$(uname -m)" = "arm64" ]; then
      $CC -O3 -mmacosx-version-min=10.4 -arch arm64 -o sleepwatcher sleepwatcher.c -framework IOKit -framework CoreFoundation
    else
      $CC -O3 -mmacosx-version-min=10.4 -arch x86_64 -o sleepwatcher sleepwatcher.c -framework IOKit -framework CoreFoundation
    fi
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man8
    install -m 0755 sleepwatcher $out/bin/sleepwatcher
    install -m 0444 ../sleepwatcher.8 $out/share/man/man8/sleepwatcher.8
  '';

  meta = {
    description = "Monitors sleep, wakeup and idleness of a Mac";
    longDescription = ''
      SleepWatcher is a command line tool (daemon) for macOS that monitors
      sleep, wakeup and idleness of a Mac. It can be used to execute a Unix
      command when the Mac or the display of the Mac goes to sleep mode or wakes
      up, after a given time without user interaction or when the user resumes
      activity after a break or when the power supply of a Mac notebook is attached
      or detached. It also can send the Mac to sleep mode or retrieve the time since
      last user activity.
    '';
    homepage = "https://www.bernhard-baehr.de/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ virusdave ];
    platforms = lib.platforms.darwin;
  };
}
