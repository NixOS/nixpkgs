{stdenv, fetchurl, perl, readline, rsh, ssh, pam}:

stdenv.mkDerivation rec {
  name = "pdsh-2.18";
  meta = {
    homepage = "https://computing.llnl.gov/linux/pdsh.html";
    description = "A high-performance, parallel remote shell utility.";
    license = "GPLv2";
  };
  src = fetchurl {
    url = "mirror://sourceforge/pdsh/${name}.tar.bz2";
    sha256 = "8c94acb17b4af8a9f553db180b4d5745c9c98844a5dc070e2ce80590e8e8a539";
  };
  buildInputs = [perl readline ssh pam];

  /* pdsh uses pthread_cancel(), which requires libgcc_s.so.1 to be
     loadable at run-time. Adding the flag below ensures that the
     library can be found. Obviously, though, this is a hack. */
  NIX_LDFLAGS="-lgcc_s";

  # Setting --with-machines=$out in configureFlags doesn't seem to work,
  # so I specify configurePhase instead.
  configurePhase = "./configure --prefix=$out --with-machines=$out/etc/machines"
                 + " " + (if readline == null then "--without-readline" else "--with-readline")
                 + " " + (if ssh == null then "--without-ssh" else "--with-ssh")
                 + " " + (if pam == null then "--without-pam" else "--with-pam")
                 + " " + (if rsh == false then "--without-rsh" else "--with-rsh")
                 + " --with-dshgroups"
                 + " --with-xcpu"
                 + " --without-genders"
                 + " --without-mqshell"
                 + " --without-mrsh"
                 + " --without-netgroup"
                 + " --without-nodeattr"
                 + " --without-nodeupdown"
                 + " --without-qshell"
                 + " --without-slurm"
                 + " --enable-fast-install"
                 + " --disable-dependency-tracking"
                 + " --disable-debug"
                 ;

  maintainers = [ stdenv.lib.maintainers.simons ];
}
