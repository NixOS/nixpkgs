{ stdenv, fetchurl, openssh, openssl }:

stdenv.mkDerivation rec {
  name = "nagios-plugins-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "http://nagios-plugins.org/download/${name}.tar.gz";
    sha256 = "074yia04py5y07sbgkvri10dv8nf41kqq1x6kmwqcix5vvm9qyy3";
  };

  # !!! Awful hack. Grrr... this of course only works on NixOS.
  # Anyway the check that configure performs to figure out the ping
  # syntax is totally impure, because it runs an actual ping to
  # localhost (which won't work for ping6 if IPv6 support isn't
  # configured on the build machine).
  preConfigure= "
    configureFlagsArray=(
      --with-ping-command='/run/wrappers/bin/ping -4 -n -U -w %d -c %d %s'
      --with-ping6-command='/run/wrappers/bin/ping -6 -n -U -w %d -c %d %s'
    )
  ";

  postInstall = "ln -s libexec $out/bin";

  # !!! make openssh a runtime dependency only
  buildInputs = [ openssh openssl ];

  meta = {
    description = "Official plugins for Nagios";
    homepage    = http://www.nagios.org/download/plugins;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice relrod ];
  };
}
