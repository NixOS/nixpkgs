{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cachefilesd-${version}";
  version = "0.10.10";

  src = fetchurl {
    url = "https://people.redhat.com/dhowells/fscache/${name}.tar.bz2";
    sha256 = "00hsw4cdlm13wijlygp8f0aq6gxdp0skbxs9r2vh5ggs3s2hj0qd";
  };

  installFlags = [
    "ETCDIR=$(out)/etc"
    "SBINDIR=$(out)/sbin"
    "MANDIR=$(out)/share/man"
  ];

  meta = with stdenv.lib; {
    description = "Local network file caching management daemon";
    homepage = https://people.redhat.com/dhowells/fscache/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
