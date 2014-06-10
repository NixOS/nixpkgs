{ stdenv, fetchurl, coreutils, pam, groff, keepVisudo ? false }:

stdenv.mkDerivation rec {
  name = "sudo-1.8.9p4";

  src = fetchurl {
    urls =
      [ "ftp://ftp.sudo.ws/pub/sudo/${name}.tar.gz"
        "ftp://ftp.sudo.ws/pub/sudo/OLD/${name}.tar.gz"
      ];
    sha256 = "19y75bsh4z2kid5jk2r84z7rvmnh90n8cb9fbn9l4rcw83lzjhqr";
  };

  postConfigure = ''
    cat >> pathnames.h <<EOF
    #undef  _PATH_SUDO_LOGFILE
    #define _PATH_SUDO_LOGFILE "/var/log/sudo.log"
    #undef  _PATH_SUDO_TIMEDIR
    #define _PATH_SUDO_TIMEDIR "/run/sudo"
    #undef  _PATH_VI
    #define _PATH_VI "/run/current-system/sw/bin/nano"
    #undef  _PATH_MV
    #define _PATH_MV "${coreutils}/bin/mv"
    EOF

    makeFlags="install_uid=$(id -u) install_gid=$(id -g)"
    installFlags="sudoers_uid=$(id -u) sudoers_gid=$(id -g) sysconfdir=$out/etc timedir=$TMPDIR/dummy"
  '';

  buildInputs = [ coreutils pam groff ];

  enableParallelBuilding = true;

  postInstall = ''
    # ‘visudo’ does not make sense on NixOS - except for checking sudoers
    # file syntax
    rm ${if keepVisudo then "" else "$out/sbin/visudo"} \
        $out/share/man/man8/visudo.8

    rm $out/share/doc/sudo/ChangeLog
  '';

  meta = {
    description = "A command to run commands as root";

    longDescription = ''
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
