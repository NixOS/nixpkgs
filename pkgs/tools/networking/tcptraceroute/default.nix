{ stdenv , pkgs , fetchurl, libpcap, libnet
}:

stdenv.mkDerivation rec {
   pkgname = "tcptraceroute";
   name = "${pkgname}-${version}";
   version = "1.5beta7";

   src = fetchurl {
     url = "https://github.com/mct/${pkgname}/archive/${name}.tar.gz";
     sha256 = "1rz8bgc6r1isb40awv1siirpr2i1paa2jc1cd3l5pg1m9522xzap";
   };

   # for reasons unknown --disable-static configure flag doesn't disable static
   # linking.. we instead override CFLAGS with -static omitted
   preBuild = ''
      makeFlagsArray=(CFLAGS=" -g -O2 -Wall")
   '';

   buildInputs = [ libpcap libnet ];

   meta = {
     description = "A traceroute implementation using TCP packets.";
     homepage = https://github.com/mct/tcptraceroute;
     license = stdenv.lib.licenses.gpl2;
     maintainers = [ stdenv.lib.maintainers.pbogdan ];
   };
}
