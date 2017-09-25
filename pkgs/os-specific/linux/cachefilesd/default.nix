{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cachefilesd-${version}";
  version = "0.10.9";

  src = fetchurl {
    url = "https://people.redhat.com/dhowells/fscache/${name}.tar.bz2";
    sha256 = "1jkb3qd8rcmli3g2qgcpp1f9kklil4qgy86w7pg2cpv10ikyr5y8";
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
