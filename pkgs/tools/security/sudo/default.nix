{stdenv, fetchurl, coreutils, pam, groff}:

stdenv.mkDerivation rec {
  name = "sudo-1.7.1";

  src = fetchurl {
    url = "ftp://ftp.sudo.ws/pub/sudo/${name}.tar.gz";
    sha256 = "1nz1mgnyrz4ibmywh379vic941qbxy7ca71cn0l1p66a9zmkj775";
  };

  # `--with-stow' allows /etc/sudoers to be a symlink.  Only it
  # doesn't really help because the target still has to have mode 0440,
  # while files in the Nix store all have mode 0444.
  #configureFlags = "--with-stow";

  postConfigure = "
    sed -e '/_PATH_MV/d; /_PATH_VI/d' -i config.h
    echo '#define _PATH_SUDO_LOGFILE \"/var/log/sudo.log\"' >> config.h
    echo '#define _PATH_SUDO_TIMEDIR \"/var/run/sudo\"' >> config.h
    echo '#define _PATH_MV \"/var/run/current-system/sw/bin/mv\"' >> config.h
    echo '#define _PATH_VI \"/var/run/current-system/sw/bin/nano\"' >> config.h
    echo '#define EDITOR _PATH_VI' >>config.h

    makeFlags=\"install_uid=$(id -u) install_gid=$(id -g)\"
    installFlags=\"sudoers_uid=$(id -u) sudoers_gid=$(id -g) sysconfdir=$out/etc\"
  ";

  buildInputs = [coreutils pam groff];

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
