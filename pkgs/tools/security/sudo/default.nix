{stdenv, fetchurl, coreutils, pam}:

stdenv.mkDerivation {
  name = "sudo-1.6.9p4";

  src = fetchurl {
    url = ftp://sunsite.ualberta.ca/pub/Mirror/sudo/sudo-1.6.9p4.tar.gz;
    sha256 = "0y65f77wxsl285yr1krfh5djcwm95n39p0yb3r1xgg98gir5z7w4";
  };

  # `--with-stow' allows /etc/sudoers to be a symlink.  Only it
  # doesn't really help because the target still has to have mode 0440,
  # while files in the Nix store all have mode 0444.
  #configureFlags = "--with-stow";

  postConfigure = "
    sed -e '/_PATH_MV/d; /_PATH_VI/d' -i config.h
    echo '#define _PATH_MV \"/var/run/current-system/sw/bin/mv\"' >> config.h
    echo '#define _PATH_VI \"/var/run/current-system/sw/bin/vi\"' >> config.h
    echo '#define EDITOR _PATH_VI' >>config.h

    makeFlags=\"install_uid=$(id -u) install_gid=$(id -g)\"
    installFlags=\"sudoers_uid=$(id -u) sudoers_gid=$(id -g) sysconfdir=$out/etc\"
  ";

  buildInputs = [coreutils pam];
}
