{ stdenv, fetchurl, coreutils, pam, groff, sssd
, sendmailPath ? "/run/wrappers/bin/sendmail"
, withInsults ? false
, withSssd ? false
}:

stdenv.mkDerivation rec {
  name = "sudo-1.8.27";

  src = fetchurl {
    urls =
      [ "ftp://ftp.sudo.ws/pub/sudo/${name}.tar.gz"
        "ftp://ftp.sudo.ws/pub/sudo/OLD/${name}.tar.gz"
      ];
    sha256 = "1h1f7v9pv0rzp14cxzv8kaa8mdd717fbqv83l7c5dvvi8jwnisvv";
  };

  prePatch = ''
    # do not set sticky bit in nix store
    substituteInPlace src/Makefile.in --replace 04755 0755
  '';

  configureFlags = [
    "--with-env-editor"
    "--with-editor=/run/current-system/sw/bin/nano"
    "--with-rundir=/run/sudo"
    "--with-vardir=/var/db/sudo"
    "--with-logpath=/var/log/sudo.log"
    "--with-iologdir=/var/log/sudo-io"
    "--with-sendmail=${sendmailPath}"
    "--enable-tmpfiles.d=no"
  ] ++ stdenv.lib.optional withInsults [
    "--with-insults"
    "--with-all-insults"
  ] ++ stdenv.lib.optional withSssd [
    "--with-sssd"
    "--with-sssd-lib=${sssd}/lib"
  ];

  configureFlagsArray = [
    "--with-passprompt=[sudo] password for %p: "  # intentional trailing space
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

  nativeBuildInputs = [ groff ];
  buildInputs = [ pam ];

  enableParallelBuilding = true;

  doCheck = false; # needs root

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

    homepage = https://www.sudo.ws/;

    license = https://www.sudo.ws/sudo/license.html;

    maintainers = [ stdenv.lib.maintainers.eelco ];

    platforms = stdenv.lib.platforms.linux;
  };
}
