{stdenv, fetchurl, openssh}:

stdenv.mkDerivation {
  name = "nagios-plugins-1.4.10";

  src = fetchurl {
    url = https://www.nagios-plugins.org/download/nagios-plugins-1.4.10.tar.gz;
    sha256 = "0vm7sjiygxbfc5vbsi1g0dakpvynfzi86fhqx4yxd61brn0g8ghr";
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

  buildInputs = [openssh]; # !!! make openssh a runtime dependency only

  meta = {
    description = "Official plugins for Nagios";
    homepage = http://www.nagios.org/;
    license = "GPL";
  };
}
