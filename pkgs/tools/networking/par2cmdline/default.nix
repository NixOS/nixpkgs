{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "par2cmdline-0.4";
  
  src = fetchurl {
    url = mirror://sourceforge/parchive/par2cmdline-0.4.tar.gz;
    sha256 = "0xznx4vgf9nd0ijm2xi2zrb42wb891ypa948z54q5jkvrzdvfcly";
  };

  patches = [
    (fetchurl {
      url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/app-arch/par2cmdline/files/par2cmdline-0.4-gcc4.patch?rev=1.1.1.1";
      sha256 = "1xrkr13qw5vqi2qbr2p43nqbq83nywk4bgvq7nfvrca4z60s787d";
    })
  ];

  meta = {
    homepage = http://parchive.sourceforge.net/;
    description = "A command-line tool for repairing downloaded files using PARs (parity archives)";
  };
}
