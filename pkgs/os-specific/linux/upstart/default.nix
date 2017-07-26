{ stdenv, fetchurl, pkgconfig, dbus, libnih, python, makeWrapper, utillinux
, writeScript }:

let
  inherit (stdenv.lib) makeBinPath;
  version = "1.5";

  upstart = stdenv.mkDerivation rec {
  name = "upstart-${version}";

  src = fetchurl {
    url = "http://upstart.ubuntu.com/download/${version}/${name}.tar.gz";
    sha256 = "01w4ab6nlisz5blb0an1sxjkndwikr7sjp0cmz4lg00g3n7gahmx";
  };

  buildInputs = [ pkgconfig dbus libnih python makeWrapper];

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

      # Patch some binaries to refer to the correct binary location.
      sed -i "s,/sbin/init,$out/bin/init,g" $out/bin/init-checkconf
      sed -i "s,initctl,$out/bin/initctl," $out/bin/initctl2dot

      # Add some missing executable permissions, and wrap binaries.
      chmod +x $out/bin/init-checkconf $out/bin/init-checkconf
      wrapProgram $out/bin/init-checkconf \
        --prefix PATH : $out/bin:${makeBinPath [utillinux dbus]}
      wrapProgram $out/bin/initctl2dot --prefix PATH : $out/bin
    '';

  meta = {
    homepage = "http://upstart.ubuntu.com/";
    description = "An event-based replacement for the /sbin/init daemon";
    platforms = stdenv.lib.platforms.linux;
  };
};

in upstart
