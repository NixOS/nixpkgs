{ lib
, stdenv
, fetchurl
, fetchpatch
, buildPackages
, coreutils
, pam
, groff
, sssd
, nixosTests
, sendmailPath ? "/run/wrappers/bin/sendmail"
, withInsults ? false
, withSssd ? false
}:

stdenv.mkDerivation rec {
  pname = "sudo";
  version = "1.9.14p3";

  src = fetchurl {
    url = "https://www.sudo.ws/dist/${pname}-${version}.tar.gz";
    hash = "sha256-oIMYscS8hYLABNTNmuKQOrxUnn5GuoFeQf6B0cB4K2I=";
  };

  patches = [
    # Extra bugfix not included in 1.9.14p3 to address a bug that impacts the
    # NixOS test suite for sudo.
    (fetchpatch {
      url = "https://github.com/sudo-project/sudo/commit/760c9c11074cb921ecc0da9fbb5f0a12afd46233.patch";
      hash = "sha256-smwyoYEkaqfQYz9C4VVz59YMtKabOPpwhS+RBwXbWuE=";
    })
    # Fix for the patch above:
    #   https://bugzilla.sudo.ws/show_bug.cgi?id=1057
    (fetchpatch {
      url = "https://github.com/sudo-project/sudo/commit/d148e7d8f9a98726dd4fde6f187c7d614e1258c7.patch";
      hash = "sha256-3I3PnuAHlBs3JOn0Ul900aFxuUkDGV4sM3S5DNtW7bE=";
    })
  ];

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
  ] ++ lib.optionals withInsults [
    "--with-insults"
    "--with-all-insults"
  ] ++ lib.optionals withSssd [
    "--with-sssd"
    "--with-sssd-lib=${sssd}/lib"
  ];

  configureFlagsArray = [
    "--with-passprompt=[sudo] password for %p: " # intentional trailing space
  ];

  postConfigure =
    ''
      cat >> pathnames.h <<'EOF'
        #undef _PATH_MV
        #define _PATH_MV "${coreutils}/bin/mv"
      EOF
      makeFlags="install_uid=$(id -u) install_gid=$(id -g)"
      installFlags="sudoers_uid=$(id -u) sudoers_gid=$(id -g) sysconfdir=$out/etc rundir=$TMPDIR/dummy vardir=$TMPDIR/dummy DESTDIR=/"
    '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ groff ];
  buildInputs = [ pam ];

  enableParallelBuilding = true;

  doCheck = false; # needs root

  postInstall = ''
    rm $out/share/doc/sudo/ChangeLog
  '';

  passthru.tests = { inherit (nixosTests) sudo; };

  meta = {
    description = "A command to run commands as root";

    longDescription =
      ''
        Sudo (su "do") allows a system administrator to delegate
        authority to give certain users (or groups of users) the ability
        to run some (or all) commands as root or another user while
        providing an audit trail of the commands and their arguments.
      '';

    homepage = "https://www.sudo.ws/";

    license = "https://www.sudo.ws/sudo/license.html";

    maintainers = with lib.maintainers; [ eelco delroth ];

    platforms = lib.platforms.linux;
  };
}
