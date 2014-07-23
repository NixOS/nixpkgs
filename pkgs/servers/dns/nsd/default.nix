{ config, stdenv, fetchurl, libevent, openssl
, bind8Stats       ? false
, checking         ? false
, ipv6             ? true
, mmap             ? false
, minimalResponses ? true
, nsec3            ? true
, ratelimit        ? false
, recvmmsg         ? false
, rootServer       ? false
}:

stdenv.mkDerivation rec {
  name = "nsd-4.0.3";

  src = fetchurl {
    url = "http://www.nlnetlabs.nl/downloads/nsd/${name}.tar.gz";
    sha256 = "4bf05f2234e1b41899198aa1070f409201fc3c4980feef6567cd92c7074c4a8b";
  };

  buildInputs = [ libevent openssl ];

  configureFlags =
    let edf = c: o: if c then ["--enable-${o}"] else ["--disable-${o}"];
     in edf bind8Stats       "bind8-stats"
     ++ edf checking         "checking"
     ++ edf ipv6             "ipv6"
     ++ edf mmap             "mmap"
     ++ edf minimalResponses "minimal-responses"
     ++ edf nsec3            "nsec3"
     ++ edf ratelimit        "ratelimit"
     ++ edf recvmmsg         "recvmmsg"
     ++ edf rootServer       "root-server"
     ++ [ "--with-ssl=${openssl}" "--with-libevent=${libevent}" ];

  meta = {
    description = "Authoritative only, high performance, simple and open source name server.";
    license = "BSD";
    homepage = http://www.nlnetlabs.nl;
    platforms = with stdenv.lib.platforms; linux;
  };
}
