{stdenv, fetchurl, perl, readline, rsh, ssh, pam}:

stdenv.mkDerivation rec {
  name = "pdsh-2.22";
  src = fetchurl {
    url = "mirror://sourceforge/pdsh/${name}.tar.bz2";
    sha256 = "1b3c5dbaa8nhw2a5h89khs501m6ywg3zfzv7zahgsvjc8zcnfg8q";
  };

  buildInputs = [perl readline ssh pam];

  /* pdsh uses pthread_cancel(), which requires libgcc_s.so.1 to be
     loadable at run-time. Adding the flag below ensures that the
     library can be found. Obviously, though, this is a hack. */
  NIX_LDFLAGS="-lgcc_s";

  preConfigure = ''
    configureFlagsArray=(
      "--infodir=$out/share/info"
      "--mandir=$out/share/man"
      "--with-machines=$out/etc/machines"
      ${if readline == null then "--without-readline" else "--with-readline"}
      ${if ssh == null then "--without-ssh" else "--with-ssh"}
      ${if pam == null then "--without-pam" else "--with-pam"}
      ${if rsh == false then "--without-rsh" else "--with-rsh"}
      "--with-dshgroups"
      "--with-xcpu"
      "--without-genders"
      "--without-mqshell"
      "--without-mrsh"
      "--without-netgroup"
      "--without-nodeattr"
      "--without-nodeupdown"
      "--without-qshell"
      "--without-slurm"
      "--disable-debug"
    )
  '';

  meta = {
    homepage = "https://computing.llnl.gov/linux/pdsh.html";
    description = "A high-performance, parallel remote shell utility.";
    license = "GPLv2";

    longDescription = ''
      Pdsh is a high-performance, parallel remote shell utility. It has
      built-in, thread-safe clients for Berkeley and Kerberos V4 rsh and
      can call SSH externally (though with reduced performance). Pdsh
      uses a "sliding window" parallel algorithm to conserve socket
      resources on the initiating node and to allow progress to continue
      while timeouts occur on some connections.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
