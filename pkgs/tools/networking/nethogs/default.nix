{ stdenv, fetchFromGitHub, ncurses, libpcap }:

stdenv.mkDerivation rec {
  name = "nethogs-${version}";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "raboof";
    repo = "nethogs";
    rev = "v${version}";
    sha256 = "13plwblwbnyyi40jaqx471gwhln08wm7f0fxyvj1yh3d81k556yx";
  };

  buildInputs = [ ncurses libpcap ];

  makeFlags = [ "VERSION=${version}" ];

  installFlags = [ "PREFIX=$(out)" "sbin=$(out)/bin" ];

  meta = with stdenv.lib; {
    description = "A small 'net top' tool, grouping bandwidth by process";
    longDescription = ''
      NetHogs is a small 'net top' tool. Instead of breaking the traffic down
      per protocol or per subnet, like most tools do, it groups bandwidth by
      process. NetHogs does not rely on a special kernel module to be loaded.
      If there's suddenly a lot of network traffic, you can fire up NetHogs
      and immediately see which PID is causing this. This makes it easy to
      identify programs that have gone wild and are suddenly taking up your
      bandwidth.
    '';
    license = licenses.gpl2Plus;
    homepage = "https://github.com/raboof/nethogs#readme";
    platforms = platforms.linux;
    maintainers = [ maintainers.rycee ];
  };
}
