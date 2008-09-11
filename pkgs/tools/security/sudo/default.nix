{stdenv, fetchurl, coreutils, pam}:

stdenv.mkDerivation rec {
  name = "sudo-1.6.9p17";

  src = fetchurl {
    url = "http://www.sudo.ws/sudo/dist/${name}.tar.gz";
    sha256 = "15j5qzwn1nl9fr6ss3b2fk803cin3w11081rgqmm8vscd3zx8b0y";
  };

  # `--with-stow' allows /etc/sudoers to be a symlink.  Only it
  # doesn't really help because the target still has to have mode 0440,
  # while files in the Nix store all have mode 0444.
  #configureFlags = "--with-stow";

  postConfigure = "
    sed -e '/_PATH_MV/d; /_PATH_VI/d' -i config.h
    echo '#define _PATH_MV \"/var/run/current-system/sw/bin/mv\"' >> config.h
    echo '#define _PATH_VI \"/var/run/current-system/sw/bin/nano\"' >> config.h
    echo '#define EDITOR _PATH_VI' >>config.h

    makeFlags=\"install_uid=$(id -u) install_gid=$(id -g)\"
    installFlags=\"sudoers_uid=$(id -u) sudoers_gid=$(id -g) sysconfdir=$out/etc\"
  ";

  buildInputs = [coreutils pam];

  meta = {
    description = "sudo, a command to run commands as root";

    longDescription = ''
      Sudo (su "do") allows a system administrator to delegate
      authority to give certain users (or groups of users) the ability
      to run some (or all) commands as root or another user while
      providing an audit trail of the commands and their arguments.
    '';

    homepage = http://www.sudo.ws/;

    license = http://www.sudo.ws/sudo/license.html;
  };
}
