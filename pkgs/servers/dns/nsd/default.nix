{ config, stdenv, fetchurl, libevent, openssl
}:

stdenv.mkDerivation rec {
  name = "nsd-4.0.3";

  src = fetchurl {
    url = "http://www.nlnetlabs.nl/downloads/nsd/${name}.tar.gz";
    sha256 = "4bf05f2234e1b41899198aa1070f409201fc3c4980feef6567cd92c7074c4a8b";
  };

  buildInputs = [ libevent openssl ];

  configureFlags =
    let flag = state: flags: if state then map (x: "--enable-${x}")  flags
                                      else map (x: "--disable-${x}") flags;
     in flag (config.nsd.bind8Stats       or false) [ "bind8-stats" ]
     ++ flag (config.nsd.checking         or false) [ "checking" ]
     ++ flag (config.nsd.ipv6             or true)  [ "ipv6" ]
     ++ flag (config.nsd.mmap             or false) [ "mmap" ]
     ++ flag (config.nsd.minimalResponses or true)  [ "minimal-responses" ]
     ++ flag (config.nsd.nsec3            or true)  [ "nsec3" ]
     ++ flag (config.nsd.ratelimit        or false) [ "ratelimit" ]
     ++ flag (config.nsd.recvmmsg         or false) [ "recvmmsg" ]
     ++ flag (config.nsd.rootServer       or false) [ "root-server" ]
     ++ [ "--with-ssl=${openssl}" "--with-libevent=${libevent}" ];

  meta = {
    description = "Authoritative only, high performance, simple and open source name server.";
    license = "BSD";
    homepage = http://www.nlnetlabs.nl;
    platforms = with stdenv.lib.platforms; linux;
  };
}
