{stdenv, fetchurl, libgcrypt, perl}:

stdenv.mkDerivation {
  name = "vpnc-0.5.1";
  src = fetchurl {
    url = http://www.unix-ag.uni-kl.de/~massar/vpnc/vpnc-0.5.1.tar.gz;
    sha256 = "f63660bd020bbe6a39e8eb67ad60c54d719046c6198a6834371d098947f9a2ed";
  };

  patches = [ ./makefile.patch ];

  buildInputs = [libgcrypt perl];
  builder = ./builder.sh;

  meta = {
    description = "VPNC, a virtual private network (VPN) client for Cisco's VPN concentrators";
    homepage = http://www.unix-ag.uni-kl.de/~massar/vpnc/;
    license = "GPL";
  };
}
