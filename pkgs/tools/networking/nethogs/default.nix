{ stdenv, fetchgit, ncurses, libpcap }:

stdenv.mkDerivation rec {
  name = "nethogs-${version}";

  version = "0.8.1-git";

  src = fetchgit {
    url = git://github.com/raboof/nethogs.git;
    rev = "f6f9e890ea731b8acdcb8906642afae4cd96baa8";
    sha256 = "0dj5sdyxdlssbnjbdf8k7x896m2zgyyg31g12dl5n6irqdrb5scf";
  };

  buildInputs = [ ncurses libpcap ];

  preConfigure = ''
    substituteInPlace Makefile --replace "prefix := /usr/local" "prefix := $out"
  '';

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
  };
}
