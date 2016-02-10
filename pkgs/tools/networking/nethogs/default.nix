{ stdenv, fetchFromGitHub, ncurses, libpcap }:

stdenv.mkDerivation rec {
  name = "nethogs-${version}";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "raboof";
    repo = "nethogs";
    rev = "v${version}";
    sha256 = "1phn6i44ysvpl1f54bx4dspy51si8rc2wq6fywi163mi25j355d4";
  };

  buildInputs = [ ncurses libpcap ];

  installFlags = [ "prefix=$(out)" "sbin=$(prefix)/bin" ];

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
    homepage = http://nethogs.sourceforge.net/;
    platforms = platforms.linux;
    maintainers = [ maintainers.rycee ];
  };
}
