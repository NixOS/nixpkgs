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
, rrtypes          ? false
, zoneStats        ? false
}:

stdenv.mkDerivation rec {
  name = "nsd-4.1.9";

  src = fetchurl {
    url = "http://www.nlnetlabs.nl/downloads/nsd/${name}.tar.gz";
    sha256 = "1wn8jm5kpp81m88c77j97850mnmd87yaw8qp3xsdwcakcd6j44dq";
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
     ++ edf rrtypes          "draft-rrtypes"
     ++ edf zoneStats        "zone-stats"
     ++ [ "--with-ssl=${openssl.dev}" "--with-libevent=${libevent.dev}" ];

  meta = with stdenv.lib; {
    homepage = http://www.nlnetlabs.nl;
    description = "Authoritative only, high performance, simple and open source name server";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.hrdinka ];
  };
}
