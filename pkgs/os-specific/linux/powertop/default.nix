{stdenv, fetchurl, ncurses, gettext}:

stdenv.mkDerivation {
  name = "powertop-1.13";
  src = fetchurl {
    url = http://www.lesswatts.org/projects/powertop/download/powertop-1.13.tar.gz;
    sha256 = "164dqp6msdaxpi2bmvwawasyrf1sfvanlc9ddp97v1wnjh46dj1b";
  };
  patches = [
    ./powertop-1.13.patch
    ./inotify_user.patch
    ./modprobe_configs.patch
  ];
  buildInputs = [ncurses gettext];
  meta = {
    description = "Analyze power consumption on Intel-based laptops";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.linux;
  };
}
