{ stdenv, fetchurl, coreutils, pam, groff }:

stdenv.mkDerivation rec {
  name = "sudo-1.8.10p3";

  src = fetchurl {
    urls =
      [ "ftp://ftp.sudo.ws/pub/sudo/${name}.tar.gz"
        "ftp://ftp.sudo.ws/pub/sudo/OLD/${name}.tar.gz"
      ];
    sha256 = "002l6h27pnhb77b65frhazbhknsxvrsnkpi43j7i0qw1lrgi7nkf";
  };

  configureFlags = [
    "--with-env-editor"
    "--with-editor=/run/current-system/sw/bin/nano"
    "--with-rundir=/var/run"
    "--with-vardir=/var/db/sudo"
    "--with-logpath=/var/log/sudo.log"
  ];

  postConfigure =
    ''
    cat >> pathnames.h <<'EOF'
      #undef _PATH_MV
      #define _PATH_MV "${coreutils}/bin/mv"
    EOF
    makeFlags="install_uid=$(id -u) install_gid=$(id -g)"
    installFlags="sudoers_uid=$(id -u) sudoers_gid=$(id -g) sysconfdir=$out/etc rundir=$TMPDIR/dummy vardir=$TMPDIR/dummy"
    '';

  buildInputs = [ coreutils pam groff ];

  enableParallelBuilding = true;

  postInstall = 
    ''
    rm -f $out/share/doc/sudo/ChangeLog
    '';

  meta = {
    description = "A command to run commands as root";

    longDescription = 
      ''
      Sudo (su "do") allows a system administrator to delegate
      authority to give certain users (or groups of users) the ability
      to run some (or all) commands as root or another user while
      providing an audit trail of the commands and their arguments.
      '';

    homepage = http://www.sudo.ws/;

    license = http://www.sudo.ws/sudo/license.html;

    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
