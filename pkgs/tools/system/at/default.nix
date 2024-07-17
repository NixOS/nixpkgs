{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  bison,
  flex,
  pam,
  perl,
  sendmailPath ? "/run/wrappers/bin/sendmail",
  atWrapperPath ? "/run/wrappers/bin/at",
}:

stdenv.mkDerivation rec {
  pname = "at";
  version = "3.2.5";

  src = fetchurl {
    # Debian is apparently the last location where it can be found.
    url = "mirror://debian/pool/main/a/at/at_${version}.orig.tar.gz";
    hash = "sha256-uwZrOJ18m7nYSjVzgDK4XDDLp9lJ91gZKtxyyUd/07g=";
  };

  patches = [
    # Remove glibc assumption
    (fetchpatch {
      url = "https://raw.githubusercontent.com/riscv/riscv-poky/master/meta/recipes-extended/at/at/0001-remove-glibc-assumption.patch";
      hash = "sha256-1UobqEZWoaq0S8DUDPuI80kTx0Gut2/VxDIwcKeGZOY=";
    })
  ];

  postPatch = ''
    # Remove chown commands and setuid bit
    substituteInPlace Makefile.in \
      --replace ' -o root ' ' ' \
      --replace ' -g root ' ' ' \
      --replace ' -o $(DAEMON_USERNAME) ' ' ' \
      --replace ' -o $(DAEMON_GROUPNAME) ' ' ' \
      --replace ' -g $(DAEMON_GROUPNAME) ' ' ' \
      --replace '$(DESTDIR)$(etcdir)' "$out/etc" \
      --replace '$(DESTDIR)$(ATJOB_DIR)' "$out/var/spool/atjobs" \
      --replace '$(DESTDIR)$(ATSPOOL_DIR)' "$out/var/spool/atspool" \
      --replace '$(DESTDIR)$(LFILE)' "$out/var/spool/atjobs/.SEQ" \
      --replace 'chown' '# skip chown' \
      --replace '6755' '0755'
  '';

  nativeBuildInputs = [
    bison
    flex
    perl # for `prove` (tests)
  ];

  buildInputs = [ pam ];

  preConfigure = ''
    export SENDMAIL=${sendmailPath}
    # Purity: force atd.pid to be placed in /var/run regardless of
    # whether it exists now.
    substituteInPlace ./configure --replace "test -d /var/run" "true"
  '';

  configureFlags = [
    "--with-etcdir=/etc/at"
    "--with-jobdir=/var/spool/atjobs"
    "--with-atspool=/var/spool/atspool"
    "--with-daemon_username=atd"
    "--with-daemon_groupname=atd"
  ];

  doCheck = true;

  # Ensure that "batch" can invoke the setuid "at" wrapper, if it exists, or
  # else we get permission errors (on NixOS). "batch" is a shell script, so
  # when the kernel executes it drops setuid perms.
  postInstall = ''
    sed -i "6i test -x ${atWrapperPath} && exec ${atWrapperPath} -qb now  # exec doesn't return" "$out/bin/batch"
  '';

  meta = with lib; {
    description = "The classical Unix `at' job scheduling command";
    license = licenses.gpl2Plus;
    homepage = "https://tracker.debian.org/pkg/at";
    changelog = "https://salsa.debian.org/debian/at/-/raw/master/ChangeLog";
    platforms = platforms.linux;
    mainProgram = "at";
  };
}
