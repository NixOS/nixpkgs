{ stdenv, fetchurl, libevent, openssl, nixosTests
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

, configFile ? "/etc/nsd/nsd.conf"
}:

stdenv.mkDerivation rec {
  pname = "nsd";
  version = "4.3.2";

  src = fetchurl {
    url = "https://www.nlnetlabs.nl/downloads/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0ac3mbn5z4nc18782m9aswdpi2m9f4665vidw0ciyigdh0pywp2v";
  };

  prePatch = ''
    substituteInPlace nsd-control-setup.sh.in --replace openssl ${openssl}/bin/openssl
  '';

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
     ++ [ "--with-ssl=${openssl.dev}"
          "--with-libevent=${libevent.dev}"
          "--with-nsd_conf_file=${configFile}"
          "--with-configdir=etc/nsd"
        ];

  patchPhase = ''
    sed 's@$(INSTALL_DATA) nsd.conf.sample $(DESTDIR)$(nsdconfigfile).sample@@g' -i Makefile.in
  '';

  passthru.tests = {
    inherit (nixosTests) nsd;
  };

  meta = with stdenv.lib; {
    homepage = "http://www.nlnetlabs.nl";
    description = "Authoritative only, high performance, simple and open source name server";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.hrdinka ];
  };
}
