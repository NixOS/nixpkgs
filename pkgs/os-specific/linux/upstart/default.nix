{ stdenv, fetchurl, pkgconfig, dbus, libnih }:

stdenv.mkDerivation rec {
  name = "upstart-0.6.6";
  
  src = fetchurl {
    url = "http://upstart.ubuntu.com/download/0.6/${name}.tar.gz";
    sha256 = "1cy962n4ljjxfxaigcnqsl9gq8j09j28g5jg19zk4lc7h1503d3s";
  };

  buildInputs = [ pkgconfig dbus libnih ];
  
  NIX_CFLAGS_COMPILE =
    ''
      -DSHELL="${stdenv.shell}"
      -DCONFFILE="/etc/init.conf"
      -DCONFDIR="/etc/init"
      -DPATH="/no-path"
    '';

  # The interface version prevents NixOS from switching to an
  # incompatible Upstart at runtime.  (Switching across reboots is
  # fine, of course.)  It should be increased whenever Upstart changes
  # in a backwards-incompatible way.  If the interface version of two
  # Upstart builds is the same, then we can switch between them at
  # runtime; otherwise we can't and we need to reboot.
  passthru.interfaceVersion = 2;

  postInstall =
    ''
      t=$out/etc/bash_completion.d
      ensureDir $t
      cp ${./upstart-bash-completion} $t/upstart
    '';

  meta = {
    homepage = "http://upstart.ubuntu.com/";
    description = "An event-based replacement for the /sbin/init daemon";
  };
}
