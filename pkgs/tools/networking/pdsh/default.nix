{stdenv, fetchurl, perl, readline, ssh, pam}:

stdenv.mkDerivation rec
{
  name = "pdsh-2.16";
  meta =
  {
    homepage = "https://computing.llnl.gov/linux/pdsh.html";
    description = "A high-performance, parallel remote shell utility.";
    license = "GPLv2";
  };
  src = fetchurl
  {
    url = "mirror://sourceforge/pdsh/${name}.tar.bz2";
    sha256 = "8891cd3b175d3075f7c71fa4ee2b077306117ada5dd8c0966caaa3b74eca3a3e";
  };
  patches = [ ./fix-missing-sys-types-h.patch ];
  buildInputs = [perl readline ssh pam];
  # Setting --with-machines=$out in configureFlags doesn't seem to work,
  # so I specify configurePhase instead.
  configurePhase = "./configure --prefix=$out --with-machines=$out/etc/machines"
                 + " " + (if readline == null then "--without-readline" else "--with-readline")
                 + " " + (if ssh == null then "--without-ssh" else "--with-ssh")
                 + " " + (if pam == null then "--without-pam" else "--with-pam")
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
}
