{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "acpid-1.0.10";
  
  src = fetchurl {
    url = "mirror://sourceforge/acpid/${name}.tar.gz";
    sha256 = "0q27adx0c0bzvy9f9zfny69iaay3b4b79b693fhaq1bkvph3qw12";
  };

  preBuild = ''
    makeFlagsArray=(BINDIR=$out/bin SBINDIR=$out/sbin MAN8DIR=$out/share/man/man8)
  '';

  meta = {
    homepage = http://acpid.sourceforge.net/;
    description = "A daemon for delivering ACPI events to userspace programs";
    license = "GPLv2+";
  };
}
