{ stdenv, fetchurl, openssh }:

stdenv.mkDerivation rec {
  name = "nagios-plugins-${version}";
  version = "2.0";

  src = fetchurl {
    url = "http://nagios-plugins.org/download/${name}.tar.gz";
    sha256 = "113nv9jqpbqpdjqilqbj1iyshxyvcmq8w94bq5ajz4dxi9j8045s";
  };

  # !!! Awful hack. Grrr... this of course only works on NixOS.
  # Anyway the check that configure performs to figure out the ping
  # syntax is totally impure, because it runs an actual ping to
  # localhost (which won't work for ping6 if IPv6 support isn't
  # configured on the build machine).
  preConfigure= "
    configureFlagsArray=(
      --with-ping-command='/var/setuid-wrappers/ping -n -U -w %d -c %d %s'
      --with-ping6-command='/var/setuid-wrappers/ping6 -n -U -w %d -c %d %s'
    )
  ";

  postInstall = "ln -s libexec $out/bin";

  # !!! make openssh a runtime dependency only
  buildInputs = [ openssh ];

  meta = {
    description = "Official plugins for Nagios";
    homepage    = http://www.nagios.org/download/plugins;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice relrod ];
  };
}
