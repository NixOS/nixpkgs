{ stdenv, fetchurl, pkgconfig, dbus, libnih }:

let version = "1.4"; in

stdenv.mkDerivation rec {
  name = "upstart-${version}";
  
  src = fetchurl {
    url = "http://upstart.ubuntu.com/download/${version}/${name}.tar.gz";
    md5 = "3aa9ddf8459b56547a6238aa77c61815";
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
      mkdir -p $t
      cp ${./upstart-bash-completion} $t/upstart
    '';

  meta = {
    homepage = "http://upstart.ubuntu.com/";
    description = "An event-based replacement for the /sbin/init daemon";
  };
}
