{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "strace-4.5.18";

  patches = [ ./strace-4.5.18-arm-syscalls.patch ];

  src = fetchurl {
    url = mirror://sourceforge/strace/strace-4.5.18.tar.bz2;
    sha256 = "1l16vax3mn2wak288g1inmn30i49vlghnvfwr0z2rwh41r3vgrwm";
  };
}
