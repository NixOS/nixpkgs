{stdenv, fetchurl}:

let bashCompletion = ./upstart-bash-completion;
in

stdenv.mkDerivation {
  name = "upstart-0.3.0";
  
  src = fetchurl {
    url = http://nixos.org/tarballs/upstart-0.3.0.tar.bz2;
    md5 = "269046f41c6418225306280044a799eb";
  };

  dontDisableStatic = true;
  
  configureFlags = "--enable-compat";
  
  patches = [./cfgdir.patch];
  
  preBuild = "export NIX_CFLAGS_COMPILE=\"$NIX_CFLAGS_COMPILE -DSHELL=\\\"$SHELL\\\"\"";

  # The interface version prevents NixOS from switching to an
  # incompatible Upstart at runtime.  (Switching across reboots is
  # fine, of course.)  It should be increased whenever Upstart changes
  # in a backwards-incompatible way.  If the interface version of two
  # Upstart builds is the same, then we can switch between them at
  # runtime; otherwise we can't and we need to reboot.
  passthru = {
    interfaceVersion = 1;
  };

  postInstall = ''
    t=$out/etc/bash_completion.d
    ensureDir $t; cp ${bashCompletion} $t/upstart
  '';

  meta = {
    homepage = "http://upstart.ubuntu.com/";
    description = "An event-based replacement for the /sbin/init daemon";
  };
}
